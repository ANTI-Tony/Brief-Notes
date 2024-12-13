import SwiftUI

struct ContentView: View {
    @StateObject private var store = TransactionStore()
    @StateObject private var settings = AppSettings()
    @State private var selectedTab = 0
    @State private var showLanguageAlert = false
    @StateObject private var currencySettings = CurrencySettings() // 添加货币设置
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("tab.home".localized())
                }
                .tag(0)
            
            StatisticsView()
                .tabItem {
                    Image(systemName: "chart.pie.fill")
                    Text("tab.statistics".localized())
                }
                .tag(1)
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("tab.settings".localized())
                }
                .tag(2)
        }
        .environmentObject(store)
        .environmentObject(settings)
        .environmentObject(currencySettings)
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("LanguageChanged"))) { _ in
            showLanguageAlert = true
        }
        .alert("Language Changed", isPresented: $showLanguageAlert) {
            Button("OK") {
                exit(0)
                    }
        } message: {
            Text("Please restart the app to apply language changes.")
        }
    }
}
