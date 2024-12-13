import Foundation
import SwiftUI

class AppSettings: ObservableObject {
    // 货币枚举
    enum Currency: String, CaseIterable {
        case cny = "CNY"
        case usd = "USD"
        case eur = "EUR"
        case gbp = "GBP"
        
        var symbol: String {
            switch self {
            case .cny: return "¥"
            case .usd: return "$"
            case .eur: return "€"
            case .gbp: return "£"
            }
        }
        
        var displayName: String {
            switch self {
            case .cny: return "人民币"
            case .usd: return "美元"
            case .eur: return "欧元"
            case .gbp: return "英镑"
            }
        }
    }
    
    // 语言枚举
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

    @Published var language: Language {
        didSet {
            UserDefaults.standard.set(language.rawValue, forKey: "app_language")
            UserDefaults.standard.set([language.rawValue], forKey: "AppleLanguages")
            UserDefaults.standard.synchronize()
            NotificationCenter.default.post(name: NSNotification.Name("LanguageChanged"), object: nil)
        }
    }
    
    @Published var currency: Currency {
        didSet {
            UserDefaults.standard.set(currency.rawValue, forKey: "selected_currency")
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
    
    init() {
        let savedLanguage = UserDefaults.standard.string(forKey: "app_language") ?? Language.english.rawValue
        self.language = Language(rawValue: savedLanguage) ?? .english
        
        let savedCurrency = UserDefaults.standard.string(forKey: "selected_currency") ?? Currency.cny.rawValue
        self.currency = Currency(rawValue: savedCurrency) ?? .cny
        
        self.monthlyBudget = UserDefaults.standard.double(forKey: "monthly_budget")
        self.notificationsEnabled = UserDefaults.standard.bool(forKey: "notifications_enabled")
    }
}

extension AppSettings {
    func resetToDefault() {
        monthlyBudget = 1800.0
        notificationsEnabled = false
        language = .chinese
        currency = .cny
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
    }
}
