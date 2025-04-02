//
//  JRNLWidget.swift
//  JRNLWidget
//
//  Created by Jungman Bae on 4/2/25.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
  func placeholder(in context: Context) -> SimpleEntry {
    SimpleEntry(date: Date(), emoji: "😀")
  }
  
  func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
    let entry = SimpleEntry(date: Date(), emoji: "😀")
    completion(entry)
  }
  
  func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
    var entries: [SimpleEntry] = []
    
    // Generate a timeline consisting of five entries an hour apart, starting from the current date.
    let currentDate = Date()
    for hourOffset in 0 ..< 5 {
      let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
      let entry = SimpleEntry(date: entryDate, emoji: "😀")
      entries.append(entry)
    }
    
    let timeline = Timeline(entries: entries, policy: .atEnd)
    completion(timeline)
  }
  
  //    func relevances() async -> WidgetRelevances<Void> {
  //        // Generate a list containing the contexts this widget is relevant in.
  //    }
}

struct SimpleEntry: TimelineEntry {
  let date: Date
  
}

struct JRNLWidgetEntryView : View {
  var entry: Provider.Entry
  
  var body: some View {
    VStack {
      Text("Time:")
      Text(entry.date, style: .time)
      
      Text("Emoji:")
      Text(entry.emoji)
    }
  }
}

struct JRNLWidget: Widget {
  let kind: String = "JRNLWidget"
  
  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: Provider()) { entry in
      if #available(iOS 17.0, *) {
        JRNLWidgetEntryView(entry: entry)
          .containerBackground(.fill.tertiary, for: .widget)
      } else {
        JRNLWidgetEntryView(entry: entry)
          .padding()
          .background()
      }
    }
    .configurationDisplayName("My Widget")
    .description("This is an example widget.")
  }
}

#Preview(as: .systemSmall) {
  JRNLWidget()
} timeline: {
  SimpleEntry(date: .now, emoji: "😀")
  SimpleEntry(date: .now, emoji: "🤩")
}
