import SwiftUI

struct ContentView: View {
    @StateObject private var store = TransactionStore()
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("首页")
                }
                .tag(0)
            
            StatisticsView()
                .tabItem {
                    Image(systemName: "chart.pie.fill")
                    Text("统计")
                }
                .tag(1)
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("设置")
                }
                .tag(2)
        }
        .environmentObject(store)
    }
}
