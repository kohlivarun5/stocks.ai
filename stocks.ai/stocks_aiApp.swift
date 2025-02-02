  //
  //  stocks_aiApp.swift
  //  stocks.ai
  //
  //  Created by Varun Kohli on 2/1/25.
  //

import SwiftUI
import SwiftData

@main
struct stocks_aiApp: App {
  var sharedModelContainer: ModelContainer = {
    let schema = Schema([
      Item.self,
    ])
    let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
    
    do {
      return try ModelContainer(for: schema, configurations: [modelConfiguration])
    } catch {
      fatalError("Could not create ModelContainer: \(error)")
    }
  }()
  
  var body: some Scene {
    
    WindowGroup {
      NavigationView {
        TabView {
          InvestmentsView()
            .tabItem {
              Label("Investments", systemImage: "chart.line.uptrend.xyaxis")
            }
            // ... other tabs ...
        }
      }
    }
    .modelContainer(sharedModelContainer)
  }
}
