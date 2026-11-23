import Foundation
import SwiftUI

@main
enum Entry {
    static func main() {
        let args = CommandLine.arguments
        if let i = args.firstIndex(of: "--selftest") {
            exit(SelfTest.run(Array(args[(i + 1)...])))
        }
        ImageShrinkApp.main()
    }
}

/// Headless mode used by the GitHub build to test the real image pipeline on macOS:
///   ImageShrink --selftest <input folder> <output folder> [maxSide] [maxBytes] [nometa]
enum SelfTest {
    static func run(_ a: [String]) -> Int32 {
        guard a.count >= 2 else {
            print("usage: --selftest <in> <out> [maxSide] [maxBytes] [nometa]")
            return 2
        }
        let input = Processor.resolved(URL(fileURLWithPath: a[0], isDirectory: true))
        let out = URL(fileURLWithPath: a[1], isDirectory: true)
        var s = ShrinkSettings()
        if a.count > 2, let v = Int(a[2]) { s.maxSide = v }
        if a.count > 3, let v = Int(a[3]) { s.maxBytes = v }
        if a.contains("nometa") { s.keepMetadata = false }
        let scan = Processor.scan(input, includeSubfolders: true)
        try? FileManager.default.createDirectory(at: out, withIntermediateDirectories: true)
        var used = Set<String>()
        var entries: [(String, ShrinkResult?)] = []
        for f in scan.files {
            let rel = Processor.relativePath(f, root: input)
            let target = Processor.targetURL(for: f, root: input, outRoot: out, usedNames: &used)
            let r = Processor.process(f, target: target, settings: s)
            entries.append((rel, r))
        }
        let log = Processor.logText(source: input, settings: s, entries: entries, outRoot: out, stopped: false)
        try? log.write(to: out.appendingPathComponent(Processor.logName), atomically: true, encoding: .utf8)
        print("SCAN files=\(scan.files.count) skipped=\(scan.skipped) subfolders=\(scan.subfolders)")
        print(log)
        return 0
    }
}
