import Foundation
import SwiftUI

class AppSettings: ObservableObject {
    @Published var language: Language {
        didSet {
            UserDefaults.standard.set(language.rawValue, forKey: "app_language")
            NotificationCenter.default.post(name: NSNotification.Name("LanguageChanged"), object: nil)
        }
    }
    
    @Published var monthlyBudget: Double {
        didSet {
            UserDefaults.standard.set(monthlyBudget, forKey: "monthly_budget")
        }
    }
    
    @Published var notificationsEnabled: Bool {
        didSet {
            UserDefaults.standard.set(notificationsEnabled, forKey: "notifications_enabled")
        }
    }
    
    enum Language: String, CaseIterable {
        case english = "en"
        case chinese = "zh"
        
        var displayName: String {
            switch self {
            case .english: return "English"
            case .chinese: return "中文"
            }
        }
        
        var locale: Locale {
            Locale(identifier: self.rawValue)
        }
    }
    
    init() {
        let savedLanguage = UserDefaults.standard.string(forKey: "app_language") ?? Language.english.rawValue
        self.language = Language(rawValue: savedLanguage) ?? .english
        self.monthlyBudget = UserDefaults.standard.double(forKey: "monthly_budget")
        self.notificationsEnabled = UserDefaults.standard.bool(forKey: "notifications_enabled")
    }
}

extension AppSettings {
    func resetToDefault() {
        monthlyBudget = 5000.0
        notificationsEnabled = false
        language = .chinese
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
    }
}
