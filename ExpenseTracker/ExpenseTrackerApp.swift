import SwiftUI

@main
struct ExpenseTrackerApp: App {
    @StateObject private var settings = AppSettings()
    @StateObject private var store = TransactionStore()
    
    init() {
        Configuration.setupInitialConfiguration()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(settings)
                .environmentObject(store)
                .environment(\.locale, settings.language.locale)
                .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("LanguageChanged"))) { _ in
                    settings.objectWillChange.send()
                }
        }
    }
    
    
}
