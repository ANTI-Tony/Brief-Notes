import SwiftUI

@main
struct ExpenseTrackerApp: App {
    @StateObject private var settings = AppSettings()
    @StateObject private var store = TransactionStore()
    
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
                .environment(\.locale, settings.language.locale)
                .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("LanguageChanged"))) { _ in
                    settings.objectWillChange.send()
                }
        }
    }
}
