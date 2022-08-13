//
//  DrinkUpWidget.swift
//  DrinkUpWidget
//
//  Created by Jaejun Shin on 13/8/2022.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date.now, waterConsumed: 1, waterRequired: 2)
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let status = getCurrentStatus()
        let entry = SimpleEntry(date: Date.now, waterConsumed: status.consumed, waterRequired: status.required)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let status = getCurrentStatus()
        let currentEntry = SimpleEntry(date: Date.now, waterConsumed: status.consumed, waterRequired: status.required)
        
        let startOfDay = Calendar.current.startOfDay(for: Date.now)
        var components = DateComponents()
        components.day = 1
        let startOfTomorrow = Calendar.current.date(byAdding: components, to: startOfDay) ?? startOfDay
            
        let tomorrowEntry = SimpleEntry(date: startOfTomorrow, waterConsumed: 0, waterRequired: status.required)
        
        let timeline = Timeline(entries: [currentEntry, tomorrowEntry], policy: .never)
        completion(timeline)
    }
    
    func getCurrentStatus() -> (consumed: Double, required: Double) {
        let defaults = UserDefaults(suiteName: "group.com.jaejunshin.TimeToDrink") ?? .standard
        
        let consumed = defaults.double(forKey: "waterConsumed")
        var required = defaults.double(forKey: "waterRequired")
        
        if required == 0 {
            required = 2000
        }
        
        return (consumed, required)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let waterConsumed: Double
    let waterRequired: Double
}

struct DrinkUpWidgetEntryView : View {
    var entry: Provider.Entry
    
    var goalProgress: Double {
        entry.waterConsumed / entry.waterRequired
    }

    var body: some View {
        ZStack {
            LinearGradient(colors: [.blue, .cyan, .blue], startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
            
            VStack {
                Image(systemName: "drop")
                    .resizable()
                    .font(.title.weight(.ultraLight))
                    .scaledToFit()
                    .background(
                        Rectangle()
                            .fill(.white)
                            .scaleEffect(x: 1, y: goalProgress, anchor: .bottom)
                    )
                    .mask {
                        Image(systemName: "drop.fill")
                            .resizable()
                            .font(.title.weight(.ultraLight))
                            .scaledToFit()
                    }
                    .padding()
            }
        }
        .foregroundColor(.white)
    }
}

@main
struct DrinkUpWidget: Widget {
    let kind: String = "DrinkUpWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            DrinkUpWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct DrinkUpWidget_Previews: PreviewProvider {
    static var previews: some View {
        DrinkUpWidgetEntryView(entry: SimpleEntry(date: Date.now, waterConsumed: 1, waterRequired: 2))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
