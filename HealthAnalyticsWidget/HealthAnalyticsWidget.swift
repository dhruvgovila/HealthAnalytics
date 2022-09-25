//
//  HealthAnalyticsWidget.swift
//  HealthAnalyticsWidget
//
//  Created by Govila, Dhruv on 25/09/2022.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> StepsEntry {
        StepsEntry(date: Date(), steps: 1000, configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (StepsEntry) -> ()) {
        let entry = StepsEntry(date: Date(), steps: 1000, configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entry: StepsEntry
        let currentDate = Date()
        let refreshDate = Calendar.current.date(byAdding: .second, value: 1, to: currentDate)!

        HealthHelper.shared.getTodaysSteps { steps in
            let entry: StepsEntry = .init(date: .now,
                                          steps: steps,
                                          configuration: configuration)
            let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
            completion(timeline)
        }
    }
}

struct StepsEntry: TimelineEntry {
    let date: Date
    let steps: Double
    let configuration: ConfigurationIntent
}

struct HealthAnalyticsWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        Text("Steps Today: \(String(format: "%.0f", entry.steps))")
    }
}

@main
struct HealthAnalyticsWidget: Widget {
    let kind: String = "HealthAnalyticsWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            HealthAnalyticsWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct HealthAnalyticsWidget_Previews: PreviewProvider {
    static var previews: some View {
        HealthAnalyticsWidgetEntryView(entry: StepsEntry(date: Date(), steps: 1000, configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
