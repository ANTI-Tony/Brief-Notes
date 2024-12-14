import SwiftUI

@main
struct ExpenseTrackerApp: App {
    @StateObject private var settings = AppSettings()
    @StateObject private var store = TransactionStore()
    @StateObject private var quickTransactionStore = QuickTransactionStore()
    
    init() {
        Configuration.setupInitialConfiguration()
        AutoRecordMonitor.shared.setup(with: store)
        AutoRecordMonitor.shared.startMonitoring()
    }
    
    var body: some Scene {
        WindowGroup {
            SplashScreenView()
                .environmentObject(settings)
                .environmentObject(store)
                .environmentObject(quickTransactionStore)
                .environment(\.locale, settings.language.locale)
                .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("LanguageChanged"))) { _ in
                    settings.objectWillChange.send()
                }
        }
    }
}
