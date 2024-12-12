import Foundation

enum Configuration {
    static let supportedLanguages = ["en", "zh"]
    
    static func setupInitialConfiguration() {
        // Set default language if not set
        if UserDefaults.standard.string(forKey: "app_language") == nil {
            let preferredLanguage = Bundle.main.preferredLocalizations.first ?? "en"
            UserDefaults.standard.set(preferredLanguage, forKey: "app_language")
        }
        
        // Register default settings
        let defaults: [String: Any] = [
            "monthly_budget": 5000.0,
            "notifications_enabled": true
        ]
        UserDefaults.standard.register(defaults: defaults)
    }
}
