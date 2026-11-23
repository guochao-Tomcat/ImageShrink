import Foundation
import ImageIO
import CoreGraphics
import UniformTypeIdentifiers

/// Settings for one run.
struct ShrinkSettings {
    var maxSide: Int = 1000
    var maxBytes: Int = 500_000          // "under 500 KB", 1 KB = 1000 bytes as Finder counts
    var convertToSRGB = true
    var includeSubfolders = true
    var keepMetadata = true
}

enum ItemStatus: Equatable {
    case ok
    case overLimit
    case failed(String)
}

struct ShrinkResult {
    var outputURL: URL?
    var width = 0
    var height = 0
    var quality = 0              // JPEG quality used, percent
    var bytes = 0
    var sourceBytes: Int64 = 0
    var status: ItemStatus
    var notes: [String] = []
    var thumb: CGImage?
}

struct ScanResult {
    var files: [URL] = []
    var totalBytes: Int64 = 0
    var byType: [String: Int] = [:]
    var skipped = 0
    var subfolders = 0
}

enum Processor {
    static let logName = "ImageShrink log.txt"
    static let imageExtensions: Set<String> = ["jpg", "jpeg", "png", "tif", "tiff", "heic", "heif",
                                                "bmp", "gif", "psd", "jp2", "webp"]
    static let qualities: [Int] = [92, 88, 84, 80, 76, 72, 68, 64, 60, 55, 50, 45, 40, 35, 30]

    // MARK: Paths

    static func resolved(_ url: URL) -> URL {
        url.standardizedFileURL.resolvingSymlinksInPath()
    }

    /// Path with symlinks resolved and macOS's "/private" alias removed, so that
    /// /tmp/x, /private/tmp/x and a symlinked folder all compare equal.
    static func canonicalPath(_ url: URL) -> String {
        var p = url.standardizedFileURL.resolvingSymlinksInPath().path
        for alias in ["/private/tmp", "/private/var", "/private/etc"] where p == alias || p.hasPrefix(alias + "/") {
            p = String(p.dropFirst("/private".count))
        }
        while p.count > 1 && p.hasSuffix("/") { p.removeLast() }
        return p
    }

    static func relativePath(_ file: URL, root: URL) -> String {
        let r = canonicalPath(root)
        let prefix = r == "/" ? "/" : r + "/"
        let p = canonicalPath(file)
        if p.hasPrefix(prefix) { return String(p.dropFirst(prefix.count)) }
        // Fall back to the unresolved paths before giving up on the folder structure
        let r2 = root.standardizedFileURL.path, p2 = file.standardizedFileURL.path
        if p2.hasPrefix(r2 + "/") { return String(p2.dropFirst(r2.count + 1)) }
        return file.lastPathComponent
    }

    /// `base`, or `base 2`, `base 3` … — whichever does not exist yet.
    static func uniqueDirectory(_ base: URL) -> URL {
        let fm = FileManager.default
        if !fm.fileExists(atPath: base.path) { return base }
        var n = 2
        while true {
            let candidate = URL(fileURLWithPath: base.path + " \(n)", isDirectory: true)
            if !fm.fileExists(atPath: candidate.path) { return candidate }
            n += 1
        }
    }

    static func isInside(_ child: URL, _ parent: URL) -> Bool {
        let c = canonicalPath(child) + "/"
        let p = canonicalPath(parent) + "/"
        return c.hasPrefix(p)
    }

    /// sRGB built from the ICC file, so ImageIO embeds the profile in the JPEG
    /// (with the named sRGB space it leaves files untagged).
    static let taggedSRGB: CGColorSpace = {
        let path = "/System/Library/ColorSync/Profiles/sRGB Profile.icc"
        if let data = FileManager.default.contents(atPath: path),
           let cs = CGColorSpace(iccData: data as CFData) {
            return cs
        }
        return CGColorSpace(name: CGColorSpace.sRGB)!
    }()

    // MARK: Scan

    static func scan(_ rootIn: URL, includeSubfolders: Bool) -> ScanResult {
        let root = resolved(rootIn)
        var result = ScanResult()
        let fm = FileManager.default
        let keys: [URLResourceKey] = [.isRegularFileKey, .isDirectoryKey, .fileSizeKey, .isSymbolicLinkKey]
        var options: FileManager.DirectoryEnumerationOptions = [.skipsHiddenFiles, .skipsPackageDescendants]
        if !includeSubfolders { options.insert(.skipsSubdirectoryDescendants) }
        guard let en = fm.enumerator(at: root, includingPropertiesForKeys: keys, options: options) else {
            return result
        }
        for case let url as URL in en {
            let v = try? url.resourceValues(forKeys: Set(keys))
            if v?.isDirectory == true {
                // Skip earlier ImageShrink output folders (they contain our log)
                if fm.fileExists(atPath: url.appendingPathComponent(logName).path) {
                    en.skipDescendants()
                    continue
                }
                if includeSubfolders { result.subfolders += 1 }
                continue
            }
            guard v?.isRegularFile == true else { continue }
            let ext = url.pathExtension.lowercased()
            guard imageExtensions.contains(ext) else {
                if url.lastPathComponent != logName { result.skipped += 1 }
                continue
            }
            result.files.append(url)
            result.totalBytes += Int64(v?.fileSize ?? 0)
            let label: String
            switch ext {
            case "jpeg": label = "JPG"
            case "tiff": label = "TIFF"
            case "tif": label = "TIFF"
            case "heif": label = "HEIC"
            default: label = ext.uppercased()
            }
            result.byType[label, default: 0] += 1
        }
        result.files.sort { $0.path.localizedStandardCompare($1.path) == .orderedAscending }
        return result
    }

    // MARK: Output name

    static func targetURL(for src: URL, root: URL, outRoot: URL, usedNames: inout Set<String>) -> URL {
        let rel = relativePath(src, root: root)
        let relDir = (rel as NSString).deletingLastPathComponent
        let base = (rel as NSString).lastPathComponent
        var stem = (base as NSString).deletingPathExtension
        let ext = (base as NSString).pathExtension.lowercased()
        let dir = relDir.isEmpty ? outRoot : outRoot.appendingPathComponent(relDir, isDirectory: true)
        func key(_ name: String) -> String { (dir.path + "/" + name).lowercased() }
        var name = stem + ".jpg"
        if usedNames.contains(key(name)) {
            if stem.utf8.count > 200 { stem = String(stem.prefix(60)) }
            name = "\(stem)_\(ext).jpg"
            var n = 2
            while usedNames.contains(key(name)) {
                name = "\(stem)_\(ext)_\(n).jpg"
                n += 1
            }
        }
        usedNames.insert(key(name))
        return dir.appendingPathComponent(name)
    }

    // MARK: Process one file

    static func process(_ src: URL, target: URL, settings: ShrinkSettings) -> ShrinkResult {
        let srcBytes = Int64((try? src.resourceValues(forKeys: [.fileSizeKey]).fileSize) ?? 0)
        func fail(_ why: String) -> ShrinkResult {
            ShrinkResult(outputURL: nil, sourceBytes: srcBytes, status: .failed(why))
        }

        guard let source = CGImageSourceCreateWithURL(src as CFURL, [kCGImageSourceShouldCache: false] as CFDictionary),
              CGImageSourceGetCount(source) > 0,
              let props = CGImageSourceCopyPropertiesAtIndex(source, 0, nil) as? [CFString: Any] else {
            return fail("Could not be read — the file may be damaged or in an unsupported format")
        }
        var w = (props[kCGImagePropertyPixelWidth] as? NSNumber)?.intValue ?? 0
        var h = (props[kCGImagePropertyPixelHeight] as? NSNumber)?.intValue ?? 0
        let orientation = (props[kCGImagePropertyOrientation] as? NSNumber)?.intValue ?? 1
        if (5...8).contains(orientation) { swap(&w, &h) }
        let longest = max(w, h)
        guard longest > 0 else { return fail("Could not be read — no image size found") }

        let targetSide = min(max(settings.maxSide, 1), longest)        // never upscale
        let thumbOptions: [CFString: Any] = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceCreateThumbnailWithTransform: true,           // applies camera rotation
            kCGImageSourceThumbnailMaxPixelSize: targetSide,
            kCGImageSourceShouldCacheImmediately: true
        ]
        guard let scaled = CGImageSourceCreateThumbnailAtIndex(source, 0, thumbOptions as CFDictionary) else {
            return fail("Could not be resized")
        }

        // Flatten onto white in an 8-bit RGB space (sRGB unless asked to keep the original RGB space)
        var notes: [String] = []
        var space = taggedSRGB
        if !settings.convertToSRGB, let own = scaled.colorSpace, own.model == .rgb {
            space = own
        } else if !settings.convertToSRGB {
            notes.append("converted to sRGB (source was not RGB)")
        }
        let rect = CGRect(x: 0, y: 0, width: scaled.width, height: scaled.height)
        guard let ctx = CGContext(data: nil, width: scaled.width, height: scaled.height,
                                  bitsPerComponent: 8, bytesPerRow: 0, space: space,
                                  bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue) else {
            return fail("Could not convert colours")
        }
        ctx.setFillColor(CGColor(red: 1, green: 1, blue: 1, alpha: 1))
        ctx.fill(rect)
        ctx.interpolationQuality = .high
        ctx.draw(scaled, in: rect)
        guard let flat = ctx.makeImage() else { return fail("Could not convert colours") }

        // Metadata (title, copyright, captions…), with orientation reset because pixels are already upright
        var metadata: CGImageMetadata? = nil
        if settings.keepMetadata, let m = CGImageSourceCopyMetadataAtIndex(source, 0, nil),
           let mutable = CGImageMetadataCreateMutableCopy(m) {
            _ = CGImageMetadataSetValueMatchingImageProperty(mutable, kCGImagePropertyTIFFDictionary,
                                                             kCGImagePropertyTIFFOrientation, 1 as CFNumber)
            metadata = mutable
        }

        // Step quality down until under the limit
        func search(_ meta: CGImageMetadata?) -> (Data, Int)? {
            var best: (Data, Int)? = nil
            for q in qualities {
                guard let d = encodeJPEG(flat, quality: q, metadata: meta) else { break }
                best = (d, q)
                if d.count < settings.maxBytes { break }
            }
            return best
        }
        guard let first = search(metadata) else { return fail("Could not be saved as JPEG") }
        var data = first.0
        var q = first.1
        if data.count >= settings.maxBytes, metadata != nil, let second = search(nil), second.0.count < data.count {
            data = second.0
            q = second.1
            notes.append("metadata dropped to save space")
        }

        do {
            try FileManager.default.createDirectory(at: target.deletingLastPathComponent(),
                                                    withIntermediateDirectories: true)
            try data.write(to: target, options: .atomic)
        } catch {
            return fail("Could not be written: \(error.localizedDescription)")
        }

        return ShrinkResult(outputURL: target, width: flat.width, height: flat.height, quality: q,
                            bytes: data.count, sourceBytes: srcBytes,
                            status: data.count < settings.maxBytes ? .ok : .overLimit,
                            notes: notes, thumb: makeThumb(flat, side: 80))
    }

    static func encodeJPEG(_ image: CGImage, quality: Int, metadata: CGImageMetadata?) -> Data? {
        let out = NSMutableData()
        guard let dest = CGImageDestinationCreateWithData(out, UTType.jpeg.identifier as CFString, 1, nil) else {
            return nil
        }
        let props: [CFString: Any] = [kCGImageDestinationLossyCompressionQuality: Double(quality) / 100.0]
        if let metadata {
            CGImageDestinationAddImageAndMetadata(dest, image, metadata, props as CFDictionary)
        } else {
            CGImageDestinationAddImage(dest, image, props as CFDictionary)
        }
        guard CGImageDestinationFinalize(dest) else { return nil }
        return out as Data
    }

    static func makeThumb(_ image: CGImage, side: Int) -> CGImage? {
        let s = Double(side) / Double(max(image.width, image.height))
        let tw = max(1, Int(Double(image.width) * s)), th = max(1, Int(Double(image.height) * s))
        guard let ctx = CGContext(data: nil, width: tw, height: th, bitsPerComponent: 8, bytesPerRow: 0,
                                  space: CGColorSpace(name: CGColorSpace.sRGB)!,
                                  bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue) else { return nil }
        ctx.interpolationQuality = .medium
        ctx.draw(image, in: CGRect(x: 0, y: 0, width: tw, height: th))
        return ctx.makeImage()
    }

    // MARK: Log

    static func logText(source: URL, settings: ShrinkSettings, entries: [(String, ShrinkResult?)],
                        outRoot: URL, stopped: Bool) -> String {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm"
        var lines = [
            "ImageShrink — \(df.string(from: Date()))",
            "Source: \(source.path)",
            "Limits: \(settings.maxSide)px longest side, under \(settings.maxBytes / 1000) KB",
            "",
            "STATUS\tSOURCE\tOUTPUT\tSIZE_PX\tQUALITY\tKB\tNOTES"
        ]
        var ok = 0, over = 0, failed = 0, notDone = 0
        for (rel, r) in entries {
            guard let r else { notDone += 1; continue }
            let out = r.outputURL.map { relativePath($0, root: outRoot) } ?? "-"
            switch r.status {
            case .ok:
                ok += 1
                lines.append("OK\t\(rel)\t\(out)\t\(r.width)x\(r.height)\t\(r.quality)\t\(r.bytes / 1000)\t\(r.notes.joined(separator: "; "))")
            case .overLimit:
                over += 1
                lines.append("OVER LIMIT\t\(rel)\t\(out)\t\(r.width)x\(r.height)\t\(r.quality)\t\(r.bytes / 1000)\t\(r.notes.joined(separator: "; "))")
            case .failed(let why):
                failed += 1
                lines.append("FAILED\t\(rel)\t-\t-\t-\t-\t\(why)")
            }
        }
        lines.append("")
        var summary = "Done: \(ok) OK, \(over) over limit, \(failed) failed (of \(entries.count))."
        if stopped { summary += " Stopped early: \(notDone) not processed." }
        lines.append(summary)
        return lines.joined(separator: "\n") + "\n"
    }
}
