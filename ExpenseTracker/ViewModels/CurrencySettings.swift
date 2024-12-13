import Foundation

class CurrencySettings: ObservableObject {
    @Published var selectedCurrency: Currency {
        didSet {
            UserDefaults.standard.set(try? JSONEncoder().encode(selectedCurrency), forKey: "selectedCurrency")
        }
    }
    
    init() {
        if let data = UserDefaults.standard.data(forKey: "selectedCurrency"),
           let currency = try? JSONDecoder().decode(Currency.self, from: data) {
            self.selectedCurrency = currency
        } else {
            self.selectedCurrency = .default
        }
    }
}
