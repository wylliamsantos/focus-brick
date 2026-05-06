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
            Text("Sessão Atual")
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(entry.snapshot.phaseLabel)
                .font(.headline)
            Text(entry.snapshot.displayTime)
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .monospacedDigit()
            Text(entry.snapshot.isRunning ? "Em andamento" : "Pausado")
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
            Text("Resumo do Dia")
                .font(.caption)
                .foregroundStyle(.secondary)
            Text("Sessões: \(entry.snapshot.todayCompletedSessions)")
            Text("Foco: \(entry.snapshot.todayFocusedMinutes) min")
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
        .configurationDisplayName("Sessão Atual")
        .description("Mostra fase atual, tempo restante e estado.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct DailySummaryWidget: Widget {
    let kind: String = "DailySummaryWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: FocusBrickProvider()) { entry in
            DailySummaryWidgetView(entry: entry)
        }
        .configurationDisplayName("Resumo do Dia")
        .description("Mostra sessões concluídas e minutos focados no dia.")
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
                    Text(entry.snapshot.phaseLabel == "Foco" ? "Foco" : "Pausa")
                        .font(.caption2)
                    Text(entry.snapshot.displayTime)
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                        .monospacedDigit()
                }
            }
            .widgetURL(URL(string: "focusbrick://current-session"))
        }
        .configurationDisplayName("Focus Brick")
        .description("Estado da sessão e tempo restante.")
        .supportedFamilies([.accessoryCircular, .accessoryRectangular])
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
