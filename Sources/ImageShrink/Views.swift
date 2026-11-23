import SwiftUI
import AppKit

struct ImageShrinkApp: App {
    @StateObject private var model = AppModel()
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var delegate

    var body: some Scene {
        WindowGroup("ImageShrink") {
            ContentView()
                .environmentObject(model)
                .frame(width: 880, height: 640)
        }
        .windowResizability(.contentSize)
        .commands {
            CommandGroup(replacing: .newItem) {
                Button("Choose Folder…") { model.chooseInput() }
                    .keyboardShortcut("o")
                    .disabled(model.phase == .processing)
            }
        }
    }
}

final class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool { true }
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.activate(ignoringOtherApps: true)
    }
}

// MARK: - Shell

struct ContentView: View {
    @EnvironmentObject var model: AppModel
    @State private var dropTargeted = false

    var body: some View {
        VStack(spacing: 0) {
            Group {
                switch model.phase {
                case .start, .scanning, .ready: SetupView(dropTargeted: dropTargeted)
                case .processing: ProcessingView()
                case .done: DoneView()
                }
            }
            .padding(.horizontal, 28)
            .padding(.vertical, 22)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)

            Divider()
            FooterView()
                .padding(.horizontal, 28)
                .padding(.vertical, 14)
                .background(Color.primary.opacity(0.025))
        }
        .dropDestination(for: URL.self) { urls, _ in
            guard model.phase != .processing, let url = urls.first else { return false }
            model.setInput(url)
            return true
        } isTargeted: { dropTargeted = $0 }
        .alert("ImageShrink", isPresented: Binding(
            get: { model.alertMessage != nil },
            set: { if !$0 { model.alertMessage = nil } })) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(model.alertMessage ?? "")
        }
    }
}

// MARK: - Setup (start / ready)

struct SetupView: View {
    @EnvironmentObject var model: AppModel
    var dropTargeted: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            if model.inputURL == nil {
                DropZone(targeted: dropTargeted)
            } else {
                FolderCard(targeted: dropTargeted)
            }
            SettingsGroup()
            HStack(spacing: 12) {
                Text("Save to").frame(width: 56, alignment: .leading)
                Text(model.outputPreview)
                    .lineLimit(1)
                    .truncationMode(.middle)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(RoundedRectangle(cornerRadius: 7).fill(Color.primary.opacity(0.04)))
                    .overlay(RoundedRectangle(cornerRadius: 7).strokeBorder(Color.primary.opacity(0.08)))
                if model.outputParent != nil {
                    Button("Reset") { model.outputParent = nil }
                }
                Button("Change…") { model.chooseOutput() }
            }
        }
    }
}

struct DropZone: View {
    @EnvironmentObject var model: AppModel
    var targeted: Bool

    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: "folder.badge.plus")
                .font(.system(size: 40, weight: .light))
                .foregroundStyle(Color.accentColor)
            Text("Drop a folder of images here")
                .font(.system(size: 17, weight: .semibold))
            Text("JPG, TIFF, PNG, HEIC, PSD and more")
                .font(.callout)
                .foregroundStyle(.secondary)
            Button("Choose Folder…") { model.chooseInput() }
                .padding(.top, 4)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 176)
        .background(RoundedRectangle(cornerRadius: 12)
            .fill(targeted ? Color.accentColor.opacity(0.08) : Color.primary.opacity(0.025)))
        .overlay(RoundedRectangle(cornerRadius: 12)
            .strokeBorder(targeted ? Color.accentColor : Color.secondary.opacity(0.45),
                          style: StrokeStyle(lineWidth: 2, dash: [6, 5])))
    }
}

struct FolderCard: View {
    @EnvironmentObject var model: AppModel
    var targeted: Bool

    var body: some View {
        HStack(spacing: 20) {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.accentColor.opacity(0.14))
                .frame(width: 84, height: 84)
                .overlay(Image(systemName: "folder")
                    .font(.system(size: 38, weight: .light))
                    .foregroundStyle(Color.accentColor))
            VStack(alignment: .leading, spacing: 6) {
                Text(model.inputURL?.lastPathComponent ?? "")
                    .font(.system(size: 20, weight: .semibold))
                    .lineLimit(1)
                    .truncationMode(.middle)
                if model.phase == .scanning {
                    HStack(spacing: 8) {
                        ProgressView().controlSize(.small)
                        Text("Looking for images…").foregroundStyle(.secondary)
                    }
                } else if let scan = model.scan {
                    Text(summary(scan)).foregroundStyle(.secondary)
                    HStack(spacing: 6) {
                        ForEach(scan.byType.sorted { $0.value > $1.value }.prefix(5), id: \.key) { kv in
                            Chip(text: "\(kv.value) \(kv.key)")
                        }
                        if scan.skipped > 0 {
                            Chip(text: "\(scan.skipped) skipped (not images)", muted: true)
                        }
                    }
                    .padding(.top, 4)
                }
            }
            Spacer(minLength: 8)
            Button("Choose Another…") { model.chooseInput() }
        }
        .padding(.horizontal, 26)
        .frame(maxWidth: .infinity)
        .frame(height: 176)
        .background(RoundedRectangle(cornerRadius: 12)
            .fill(targeted ? Color.accentColor.opacity(0.08) : Color.primary.opacity(0.025)))
        .overlay(RoundedRectangle(cornerRadius: 12)
            .strokeBorder(targeted ? Color.accentColor : Color.primary.opacity(0.1), lineWidth: targeted ? 2 : 1))
    }

    private func summary(_ s: ScanResult) -> String {
        var parts = ["\(s.files.count) image\(s.files.count == 1 ? "" : "s")", Fmt.size(s.totalBytes)]
        if model.includeSubfolders { parts.append("\(s.subfolders) subfolder\(s.subfolders == 1 ? "" : "s")") }
        return parts.joined(separator: " · ")
    }
}

struct Chip: View {
    var text: String
    var muted = false
    var body: some View {
        Text(text)
            .font(.system(size: 12))
            .foregroundStyle(muted ? .secondary : .primary)
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(RoundedRectangle(cornerRadius: 5).fill(Color.primary.opacity(0.07)))
    }
}

struct SettingsGroup: View {
    @EnvironmentObject var model: AppModel

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Output")
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(.secondary)
                .padding(.leading, 4)
            VStack(spacing: 0) {
                SettingRow("Longest side") { NumberField(value: $model.maxSide, unit: "px") }
                Divider()
                SettingRow("Keep each file under") { NumberField(value: $model.maxKB, unit: "KB") }
                Divider()
                SettingRow("Format") {
                    Text("JPEG · quality adjusts automatically").foregroundStyle(.secondary)
                }
                Divider()
                SettingRow("Convert colour to sRGB for the web") {
                    Toggle("Convert colour to sRGB", isOn: $model.convertToSRGB).labelsHidden().toggleStyle(.switch)
                }
                Divider()
                SettingRow("Keep title, copyright and other metadata") {
                    Toggle("Keep metadata", isOn: $model.keepMetadata).labelsHidden().toggleStyle(.switch)
                }
                Divider()
                SettingRow("Include subfolders") {
                    Toggle("Include subfolders", isOn: $model.includeSubfolders).labelsHidden().toggleStyle(.switch)
                }
            }
            .background(RoundedRectangle(cornerRadius: 10).fill(Color.primary.opacity(0.035)))
            .overlay(RoundedRectangle(cornerRadius: 10).strokeBorder(Color.primary.opacity(0.08)))
        }
    }
}

struct SettingRow<Content: View>: View {
    let title: String
    let content: Content
    init(_ title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    var body: some View {
        HStack {
            Text(title)
            Spacer()
            content
        }
        .padding(.horizontal, 16)
        .frame(height: 38)
    }
}

struct NumberField: View {
    @Binding var value: Int
    var unit: String
    var body: some View {
        HStack(spacing: 6) {
            TextField(unit, value: $value, format: .number.grouping(.never))
                .multilineTextAlignment(.trailing)
                .textFieldStyle(.roundedBorder)
                .frame(width: 72)
            Text(unit).foregroundStyle(.secondary).frame(width: 22, alignment: .leading)
        }
    }
}

// MARK: - Processing

struct ProcessingView: View {
    @EnvironmentObject var model: AppModel

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .firstTextBaseline) {
                    Text(model.isPaused
                         ? "Paused at \(model.processedCount) of \(model.total)"
                         : "Resizing \(min(model.processedCount + 1, model.total)) of \(model.total)")
                        .font(.system(size: 20, weight: .semibold))
                    Spacer()
                    TimelineView(.periodic(from: .now, by: 1)) { _ in
                        Text(model.etaText).foregroundStyle(.secondary)
                    }
                }
                ProgressView(value: Double(model.processedCount), total: Double(max(model.total, 1)))
                    .progressViewStyle(.linear)
                Text(model.currentName.isEmpty ? " " : "Now: \(model.currentName)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                    .truncationMode(.middle)
            }
            HStack(spacing: 12) {
                StatTile(label: "Saved", value: "\(model.okCount + model.overCount)")
                StatTile(label: "Average size", value: model.averageBytes > 0 ? Fmt.kb(model.averageBytes) : "—")
                StatTile(label: "Needs attention", value: "\(model.attentionItems.count)",
                         warn: !model.attentionItems.isEmpty)
            }
            ResultsTable(items: model.doneItems)
        }
    }
}

struct StatTile: View {
    var label: String
    var value: String
    var warn = false
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label).font(.system(size: 12)).foregroundStyle(.secondary)
            Text(value)
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(warn ? Color.orange : Color.primary)
                .lineLimit(1)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 11)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.primary.opacity(0.035)))
        .overlay(RoundedRectangle(cornerRadius: 10).strokeBorder(Color.primary.opacity(0.08)))
    }
}

struct Thumb: View {
    var image: CGImage?
    var body: some View {
        Group {
            if let image {
                Image(decorative: image, scale: 1).resizable().aspectRatio(contentMode: .fill)
            } else {
                Color.primary.opacity(0.08)
            }
        }
        .frame(width: 36, height: 36)
        .clipShape(RoundedRectangle(cornerRadius: 5))
    }
}

struct ResultsTable: View {
    var items: [FileItem]

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text("").frame(width: 50)
                Text("File").frame(maxWidth: .infinity, alignment: .leading)
                Text("Size (px)").frame(width: 110, alignment: .leading)
                Text("Quality").frame(width: 64, alignment: .leading)
                Text("File size").frame(width: 76, alignment: .leading)
                Text("Status").frame(width: 104, alignment: .leading)
            }
            .font(.system(size: 12, weight: .medium))
            .foregroundStyle(.secondary)
            .padding(.horizontal, 14)
            .padding(.vertical, 7)
            .background(Color.primary.opacity(0.035))
            Divider()
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(items) { item in
                        Row(item: item)
                        Divider().opacity(0.5)
                    }
                }
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay(RoundedRectangle(cornerRadius: 10).strokeBorder(Color.primary.opacity(0.08)))
    }

    struct Row: View {
        var item: FileItem
        var body: some View {
            let r = item.result
            HStack(spacing: 0) {
                Thumb(image: r?.thumb).frame(width: 50, alignment: .leading)
                Text(item.rel)
                    .lineLimit(1)
                    .truncationMode(.middle)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.trailing, 10)
                Text(r.flatMap { $0.outputURL == nil ? nil : "\($0.width) × \($0.height)" } ?? "—")
                    .foregroundStyle(.secondary).frame(width: 110, alignment: .leading)
                Text(r.flatMap { $0.outputURL == nil ? nil : "\($0.quality)" } ?? "—")
                    .foregroundStyle(.secondary).frame(width: 64, alignment: .leading)
                Text(r.flatMap { $0.outputURL == nil ? nil : Fmt.kb($0.bytes) } ?? "—")
                    .frame(width: 76, alignment: .leading)
                StatusLabel(item: item).frame(width: 104, alignment: .leading)
            }
            .font(.system(size: 13))
            .padding(.horizontal, 14)
            .padding(.vertical, 6)
        }
    }
}

struct StatusLabel: View {
    var item: FileItem
    var body: some View {
        if item.working {
            HStack(spacing: 6) {
                ProgressView().controlSize(.mini)
                Text("Working…")
            }
            .foregroundStyle(Color.accentColor)
        } else if let r = item.result {
            switch r.status {
            case .ok:
                Label("Done", systemImage: "checkmark").foregroundStyle(Color.green)
            case .overLimit:
                Label("Over limit", systemImage: "exclamationmark.triangle").foregroundStyle(Color.orange)
            case .failed:
                Label("Failed", systemImage: "xmark.octagon").foregroundStyle(Color.red)
            }
        } else {
            Text("Waiting").foregroundStyle(.secondary)
        }
    }
}

// MARK: - Done

struct DoneView: View {
    @EnvironmentObject var model: AppModel

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack(spacing: 16) {
                Circle()
                    .fill((model.wasCancelled ? Color.orange : Color.green).opacity(0.15))
                    .frame(width: 52, height: 52)
                    .overlay(Image(systemName: model.wasCancelled ? "stop.fill" : "checkmark")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(model.wasCancelled ? Color.orange : Color.green))
                VStack(alignment: .leading, spacing: 4) {
                    Text(model.wasCancelled ? "Stopped" : "Finished").font(.system(size: 22, weight: .semibold))
                    Text(subtitle).foregroundStyle(.secondary)
                }
            }

            HStack(spacing: 12) {
                StatTile(label: "Before", value: Fmt.size(model.processedSourceBytes))
                StatTile(label: "After", value: Fmt.size(Int64(model.savedBytes)))
                StatTile(label: "Largest file", value: model.largestBytes > 0 ? Fmt.kb(model.largestBytes) : "—")
                StatTile(label: "Time", value: Fmt.duration(model.endDate.timeIntervalSince(model.startDate)))
            }

            VStack(alignment: .leading, spacing: 8) {
                Text(model.attentionItems.isEmpty ? "Needs attention" : "Needs attention (\(model.attentionItems.count))")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(.secondary)
                    .padding(.leading, 4)
                if model.attentionItems.isEmpty {
                    HStack(spacing: 10) {
                        Image(systemName: "checkmark.circle").foregroundStyle(Color.green)
                        Text("Nothing — every image is within the limits.")
                    }
                    .padding(14)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.primary.opacity(0.035)))
                } else {
                    ScrollView {
                        VStack(spacing: 0) {
                            ForEach(model.attentionItems) { item in
                                AttentionRow(item: item)
                                Divider()
                            }
                        }
                    }
                    .frame(maxHeight: 190)
                    .overlay(RoundedRectangle(cornerRadius: 10).strokeBorder(Color.primary.opacity(0.08)))
                }
            }

            HStack(spacing: 10) {
                Image(systemName: "folder").foregroundStyle(.secondary)
                Text((model.outputRoot?.path as NSString?)?.abbreviatingWithTildeInPath ?? "")
                    .lineLimit(1)
                    .truncationMode(.middle)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Button("Show Log") { model.openLog() }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 9)
            .background(RoundedRectangle(cornerRadius: 10).fill(Color.primary.opacity(0.035)))
        }
    }

    private var subtitle: String {
        let saved = model.okCount
        var s = "\(saved) of \(model.total) image\(model.total == 1 ? "" : "s") saved · \(model.runMaxSide) px max · under \(model.runMaxKB) KB"
        if model.wasCancelled { s += " · \(model.total - model.processedCount) not processed" }
        return s
    }
}

extension AppModel {
    var runMaxSide: Int { settings.maxSide }
    var runMaxKB: Int { settings.maxBytes / 1000 }
}

struct AttentionRow: View {
    @EnvironmentObject var model: AppModel
    var item: FileItem

    var body: some View {
        HStack(spacing: 14) {
            Thumb(image: item.result?.thumb)
            VStack(alignment: .leading, spacing: 2) {
                Text(item.rel).fontWeight(.medium).lineLimit(1).truncationMode(.middle)
                Text(detail).font(.system(size: 12)).foregroundStyle(detailColor)
            }
            Spacer()
            if model.retrying.contains(item.id) {
                ProgressView().controlSize(.small)
            } else if item.result?.status == .overLimit {
                Button("Retry at \(model.retrySide) px") { model.retrySmaller(item) }
            } else {
                Button("Show in Finder") { model.reveal(item.source) }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
    }

    private var detail: String {
        guard let r = item.result else { return "" }
        switch r.status {
        case .ok: return "Fixed — \(Fmt.kb(r.bytes)) at \(r.width) × \(r.height)"
        case .overLimit: return "Still \(Fmt.kb(r.bytes)) at the lowest quality — very fine detail"
        case .failed(let why): return why
        }
    }
    private var detailColor: Color {
        switch item.result?.status {
        case .some(.ok): return .green
        case .some(.overLimit): return .orange
        default: return .red
        }
    }
}

// MARK: - Footer

struct FooterView: View {
    @EnvironmentObject var model: AppModel

    var body: some View {
        HStack {
            switch model.phase {
            case .start:
                Text("No folder chosen · originals are never changed").foregroundStyle(.secondary)
                Spacer()
                Button("Start") {}.disabled(true).controlSize(.large)
            case .scanning:
                Text("Looking for images…").foregroundStyle(.secondary)
                Spacer()
                Button("Start") {}.disabled(true).controlSize(.large)
            case .ready:
                let empty = model.scan?.files.isEmpty ?? true
                Text(empty ? "No images found in this folder" : "Ready · originals are never changed")
                    .foregroundStyle(.secondary)
                Spacer()
                Button("Start") { model.start() }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    .keyboardShortcut(.defaultAction)
                    .disabled(empty)
            case .processing:
                Text("Saving to \((model.outputRoot?.path as NSString?)?.abbreviatingWithTildeInPath ?? "")")
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                    .truncationMode(.middle)
                Spacer()
                Button(model.isPaused ? "Resume" : "Pause") { model.togglePause() }.controlSize(.large)
                Button("Cancel") { model.cancel() }.controlSize(.large)
            case .done:
                Button("Do Another Folder") { model.reset() }.controlSize(.large)
                Spacer()
                Button("Open Folder") { model.openOutput() }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    .keyboardShortcut(.defaultAction)
            }
        }
    }
}
