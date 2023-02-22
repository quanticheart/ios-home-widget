//
//  widgetext.swift
//  widgetext
//
//  Created by Jonn Alves on 22/02/23.
//

import WidgetKit
import SwiftUI
import Intents

private var user: User = User(username:"User",isPrivate: true, ringtone: "wave")

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
          SimpleEntry(date: Date(), configuration: ConfigurationIntent(), user: user)
      }

      func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
          let entry = SimpleEntry(date: Date(),configuration: configuration,user: user)
          completion(entry)
      }

    
    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        let sharedDefaults = UserDefaults(suiteName: "group.com.quanticheart.widgettest")

        if(sharedDefaults != nil) {
            do {
            let shared = sharedDefaults!.string(forKey: "user")

              if(shared != nil){
                let decoder = JSONDecoder()
                user = try decoder.decode(User.self, from: shared!.data(using: .utf8)!)
              }
            } catch {
              print(error)
            }
        }

        let currentDate = Date()
        let entryDate = Calendar.current.date(byAdding: .hour, value: 24, to: currentDate)!
        let entry = SimpleEntry(date: entryDate, configuration: configuration,user: user)
        entries.append(entry)

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
    let user: User?
}

struct widgetextEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family: WidgetFamily
    
    private var FlutterDataView: some View {
        VStack{
            Text(entry.user!.username)
            Text(entry.user!.isPrivate.description)
            Text(entry.user!.ringtone)
        }
    }
    
    private var NoDataView: some View {
      Text("No data found. 😐 \nAdd data using Flutter App.").multilineTextAlignment(.center)
    }
    
    @ViewBuilder
    private func getViewWidget() -> some View {
        if(entry.user == nil) {
            NoDataView
        } else {
            FlutterDataView
        }
    }
    
    var body: some View {
        switch family {
        case .systemSmall: getViewWidget()
        case .systemMedium: getViewWidget()
        case .systemLarge: getViewWidget()
        case .systemExtraLarge: getViewWidget()
        case .accessoryCircular:
            getViewWidget()
        case .accessoryRectangular:
            getViewWidget()
        case .accessoryInline:
            getViewWidget()
        @unknown default:
            getViewWidget()
        }
        
    }
}

struct widgetext: Widget {
    let kind: String = "widgetext"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            widgetextEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct User:  Decodable, Hashable {
    var username: String
    var isPrivate: Bool
    var ringtone: String
}


struct widgetext_Previews: PreviewProvider {
    static var previews: some View {
        widgetextEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent(), user: user))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
