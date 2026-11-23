import Foundation
import AppKit
import SwiftUI

struct FileItem: Identifiable {
    let id = UUID()
    let source: URL
    let rel: String
    let target: URL
    var result: ShrinkResult? = nil
    var working = false
}

/// Pause/cancel flags read from the background worker.
final class RunControl: @unchecked Sendable {
    private let lock = NSLock()
    private var paused = false
    private var cancelled = false
    var isPaused: Bool { lock.lock(); defer { lock.unlock() }; return paused }
    var isCancelled: Bool { lock.lock(); defer { lock.unlock() }; return cancelled }
    func setPaused(_ v: Bool) { lock.lock(); paused = v; lock.unlock() }
    func cancel() { lock.lock(); cancelled = true; lock.unlock() }
    func reset() { lock.lock(); paused = false; cancelled = false; lock.unlock() }
}

@MainActor
final class AppModel: ObservableObject {
    enum Phase { case start, scanning, ready, processing, done }

    @Published var phase: Phase = .start
    @Published var maxSide: Int = 1000
    @Published var maxKB: Int = 500
    @Published var convertToSRGB = true
    @Published var keepMetadata = true
    @Published var includeSubfolders = true {
        didSet { if oldValue != includeSubfolders, inputURL != nil, phase == .ready { rescan() } }
    }
    @Published var inputURL: URL?
    @Published var outputParent: URL?
    @Published var scan: ScanResult?
    @Published var items: [FileItem] = []
    @Published var processedCount = 0
    @Published var isPaused = false
    @Published var wasCancelled = false
    @Published var outputRoot: URL?
    @Published var startDate = Date()
    @Published var endDate = Date()
    @Published var alertMessage: String?
    @Published var retrying: Set<UUID> = []

    private let control = RunControl()
    private var scanToken = UUID()
    private var runSettings = ShrinkSettings()

    var settings: ShrinkSettings {
        ShrinkSettings(maxSide: min(max(maxSide, 16), 20000),
                       maxBytes: min(max(maxKB, 5), 100_000) * 1000,
                       convertToSRGB: convertToSRGB,
                       includeSubfolders: includeSubfolders,
                       keepMetadata: keepMetadata)
    }

    // MARK: Choosing folders

    func chooseInput() {
        let panel = NSOpenPanel()
        panel.canChooseDirectories = true
        panel.canChooseFiles = false
        panel.allowsMultipleSelection = false
        panel.prompt = "Choose"
        panel.message = "Choose the folder of high-res images"
        if panel.runModal() == .OK, let url = panel.url { setInput(url) }
    }

    func setInput(_ url: URL) {
        var isDir: ObjCBool = false
        let resolved = Processor.resolved(url)
        guard FileManager.default.fileExists(atPath: resolved.path, isDirectory: &isDir), isDir.boolValue else {
            alertMessage = "Please choose a folder, not a single file."
            return
        }
        inputURL = resolved
        if let parent = outputParent, Processor.isInside(parent, resolved) { outputParent = nil }
        rescan()
    }

    func rescan() {
        guard let input = inputURL else { return }
        phase = .scanning
        let token = UUID()
        scanToken = token
        let sub = includeSubfolders
        Task.detached(priority: .userInitiated) {
            let r = Processor.scan(input, includeSubfolders: sub)
            await MainActor.run {
                guard self.scanToken == token else { return }
                self.scan = r
                self.phase = .ready
            }
        }
    }

    func chooseOutput() {
        let panel = NSOpenPanel()
        panel.canChooseDirectories = true
        panel.canChooseFiles = false
        panel.canCreateDirectories = true
        panel.prompt = "Save Here"
        panel.message = "Choose where to put the resized folder"
        guard panel.runModal() == .OK, let url = panel.url else { return }
        if let input = inputURL, Processor.isInside(url, input) {
            alertMessage = "Please choose a location outside “\(input.lastPathComponent)”. Saving inside the source folder would mix the copies with the originals."
            return
        }
        outputParent = Processor.resolved(url)
    }

    var plannedOutput: URL? {
        guard let input = inputURL else { return nil }
        let parent = outputParent ?? input.deletingLastPathComponent()
        return parent.appendingPathComponent("\(input.lastPathComponent)_\(settings.maxSide)px", isDirectory: true)
    }

    var outputPreview: String {
        if let p = plannedOutput { return (p.path as NSString).abbreviatingWithTildeInPath }
        if let parent = outputParent {
            return (parent.path as NSString).abbreviatingWithTildeInPath + "/folder name_\(settings.maxSide)px"
        }
        return "Next to the source folder, as “folder name_\(settings.maxSide)px”"
    }

    // MARK: Running

    func start() {
        guard let input = inputURL, let scan, !scan.files.isEmpty, let planned = plannedOutput else { return }
        let out = Processor.uniqueDirectory(planned)
        do {
            try FileManager.default.createDirectory(at: out, withIntermediateDirectories: true)
        } catch {
            alertMessage = "Could not create the output folder:\n\(out.path)\n\n\(error.localizedDescription)"
            return
        }
        let s = settings
        runSettings = s
        var used = Set<String>()
        items = scan.files.map { f in
            FileItem(source: f, rel: Processor.relativePath(f, root: input),
                     target: Processor.targetURL(for: f, root: input, outRoot: out, usedNames: &used))
        }
        outputRoot = out
        processedCount = 0
        isPaused = false
        wasCancelled = false
        control.reset()
        startDate = Date()
        phase = .processing

        let work = items.map { ($0.source, $0.target) }
        let control = self.control
        Task.detached(priority: .userInitiated) {
            for (idx, job) in work.enumerated() {
                if control.isCancelled { break }
                while control.isPaused && !control.isCancelled {
                    try? await Task.sleep(nanoseconds: 200_000_000)
                }
                if control.isCancelled { break }
                await MainActor.run { self.items[idx].working = true }
                let r = autoreleasepool { Processor.process(job.0, target: job.1, settings: s) }
                await MainActor.run {
                    self.items[idx].working = false
                    self.items[idx].result = r
                    self.processedCount = idx + 1
                }
            }
            await MainActor.run { self.finish() }
        }
    }

    func togglePause() {
        isPaused.toggle()
        control.setPaused(isPaused)
    }

    func cancel() {
        wasCancelled = true
        control.cancel()
    }

    private func finish() {
        endDate = Date()
        isPaused = false
        writeLog()
        phase = .done
    }

    func writeLog() {
        guard let input = inputURL, let out = outputRoot else { return }
        let text = Processor.logText(source: input, settings: runSettings,
                                     entries: items.map { ($0.rel, $0.result) },
                                     outRoot: out, stopped: wasCancelled)
        try? text.write(to: out.appendingPathComponent(Processor.logName), atomically: true, encoding: .utf8)
    }

    var retrySide: Int { max(16, Int(Double(runSettings.maxSide) * 0.9)) }

    func retrySmaller(_ item: FileItem) {
        guard let idx = items.firstIndex(where: { $0.id == item.id }) else { return }
        var s = runSettings
        s.maxSide = retrySide
        retrying.insert(item.id)
        let src = item.source, target = item.target, id = item.id
        Task.detached(priority: .userInitiated) {
            let r = Processor.process(src, target: target, settings: s)
            await MainActor.run {
                if idx < self.items.count, self.items[idx].id == id { self.items[idx].result = r }
                self.retrying.remove(id)
                self.writeLog()
            }
        }
    }

    func reset() {
        phase = .start
        inputURL = nil
        scan = nil
        items = []
        outputRoot = nil
        processedCount = 0
        wasCancelled = false
    }

    // MARK: Finder

    func openOutput() { if let o = outputRoot { NSWorkspace.shared.open(o) } }
    func openLog() {
        if let o = outputRoot { NSWorkspace.shared.open(o.appendingPathComponent(Processor.logName)) }
    }
    func reveal(_ url: URL) { NSWorkspace.shared.activateFileViewerSelecting([url]) }

    // MARK: Figures for the screens

    var total: Int { items.count }
    var results: [ShrinkResult] { items.compactMap { $0.result } }
    var okCount: Int { results.filter { $0.status == .ok }.count }
    var overCount: Int { results.filter { $0.status == .overLimit }.count }
    var failedCount: Int { results.filter { if case .failed = $0.status { return true } else { return false } }.count }
    var attentionItems: [FileItem] {
        items.filter { item in
            guard let r = item.result else { return false }
            return r.status != .ok
        }
    }
    var savedBytes: Int { results.filter { $0.outputURL != nil }.reduce(0) { $0 + $1.bytes } }
    var processedSourceBytes: Int64 { results.reduce(0) { $0 + $1.sourceBytes } }
    var largestBytes: Int { results.map { $0.bytes }.max() ?? 0 }
    var averageBytes: Int {
        let saved = results.filter { $0.outputURL != nil }
        return saved.isEmpty ? 0 : saved.reduce(0) { $0 + $1.bytes } / saved.count
    }
    var currentName: String { items.first(where: { $0.working })?.rel ?? "" }
    var doneItems: [FileItem] { items.filter { $0.working || $0.result != nil }.reversed() }

    var etaText: String {
        guard processedCount > 0, !isPaused else { return isPaused ? "Paused" : "Estimating…" }
        let elapsed = Date().timeIntervalSince(startDate)
        let remaining = elapsed / Double(processedCount) * Double(total - processedCount)
        if remaining < 5 { return "Almost done" }
        return "About \(Fmt.duration(remaining)) left"
    }
}

enum Fmt {
    static func kb(_ bytes: Int) -> String { "\(bytes / 1000) KB" }
    static func size(_ bytes: Int64) -> String {
        ByteCountFormatter.string(fromByteCount: bytes, countStyle: .file)
    }
    static func duration(_ t: TimeInterval) -> String {
        let f = DateComponentsFormatter()
        f.allowedUnits = t >= 60 ? [.hour, .minute, .second] : [.second]
        f.unitsStyle = .abbreviated
        f.maximumUnitCount = 2
        return f.string(from: max(t, 1)) ?? "\(Int(t)) s"
    }
}
