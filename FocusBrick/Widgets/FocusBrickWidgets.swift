import WidgetKit
import SwiftUI

struct FocusBrickEntry: TimelineEntry {
    let date: Date
    let snapshot: SessionSnapshot
}

struct FocusBrickProvider: TimelineProvider {
    private let store = UserDefaultsSessionStore()

    func placeholder(in context: Context) -> FocusBrickEntry {
        FocusBrickEntry(date: .now, snapshot: .empty)
    }

    func getSnapshot(in context: Context, completion: @escaping (FocusBrickEntry) -> Void) {
        let snapshot = store.loadWidgetSnapshot() ?? .empty
        completion(FocusBrickEntry(date: .now, snapshot: snapshot))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<FocusBrickEntry>) -> Void) {
        let snapshot = store.loadWidgetSnapshot() ?? .empty
        let entry = FocusBrickEntry(date: .now, snapshot: snapshot)
        let next = Calendar.current.date(byAdding: .minute, value: 1, to: .now) ?? .now.addingTimeInterval(60)
        completion(Timeline(entries: [entry], policy: .after(next)))
    }
}

struct CurrentSessionWidgetView: View {
    let entry: FocusBrickEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Current Session")
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(entry.snapshot.phaseLabel)
                .font(.headline)
            Text(entry.snapshot.displayTime)
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .monospacedDigit()
            Text(entry.snapshot.isRunning ? "Running" : "Paused")
                .font(.caption2)
                .foregroundStyle(entry.snapshot.isRunning ? .green : .orange)
        }
        .containerBackground(.fill.tertiary, for: .widget)
        .widgetURL(URL(string: "focusbrick://current-session"))
    }
}

struct DailySummaryWidgetView: View {
    let entry: FocusBrickEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Daily Summary")
                .font(.caption)
                .foregroundStyle(.secondary)
            Text("Sessions: \(entry.snapshot.todayCompletedSessions)")
            Text("Focus: \(entry.snapshot.todayFocusedMinutes) min")
                .font(.headline)
        }
        .containerBackground(.fill.tertiary, for: .widget)
        .widgetURL(URL(string: "focusbrick://daily-summary"))
    }
}

struct CurrentSessionWidget: Widget {
    let kind: String = "CurrentSessionWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: FocusBrickProvider()) { entry in
            CurrentSessionWidgetView(entry: entry)
        }
        .configurationDisplayName("Current Session")
        .description("Shows current phase, remaining time, and status.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct DailySummaryWidget: Widget {
    let kind: String = "DailySummaryWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: FocusBrickProvider()) { entry in
            DailySummaryWidgetView(entry: entry)
        }
        .configurationDisplayName("Daily Summary")
        .description("Shows completed sessions and focused minutes for today.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct FocusComplicationWidget: Widget {
    let kind: String = "FocusComplicationWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: FocusBrickProvider()) { entry in
            ZStack {
                AccessoryWidgetBackground()
                VStack(spacing: 2) {
                    Text(entry.snapshot.phaseLabel == "Focus" ? "Focus" : "Break")
                        .font(.caption2)
                    Text(entry.snapshot.displayTime)
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                        .monospacedDigit()
                }
            }
            .widgetURL(URL(string: "focusbrick://current-session"))
        }
        .configurationDisplayName("Focus Brick")
        .description("Session state and remaining time.")
        #if os(watchOS)
        .supportedFamilies([.accessoryCircular, .accessoryRectangular])
        #else
        .supportedFamilies([.systemSmall])
        #endif
    }
}

@main
struct FocusBrickWidgets: WidgetBundle {
    var body: some Widget {
        CurrentSessionWidget()
        DailySummaryWidget()
        FocusComplicationWidget()
    }
}
