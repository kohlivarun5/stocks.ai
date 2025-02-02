var body: some Scene {
    WindowGroup {
        TabView {
            InvestmentsView()
                .tabItem {
                    Label("Investments", systemImage: "chart.line.uptrend.xyaxis")
                }
            // ... other tabs ...
        }
    }
} 