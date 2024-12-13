import Foundation

struct Currency: Codable, Identifiable {
    let id: String // 例如: "CNY", "USD"
    let symbol: String // 例如: "¥", "$"
    let name: String // 例如: "人民币", "美元"
    
    static let `default` = Currency(id: "CNY", symbol: "¥", name: "人民币")
    
    static let availableCurrencies = [
        Currency(id: "CNY", symbol: "¥", name: "人民币"),
        Currency(id: "USD", symbol: "$", name: "美元"),
        Currency(id: "EUR", symbol: "€", name: "欧元"),
        Currency(id: "GBP", symbol: "£", name: "英镑"),
        Currency(id: "JPY", symbol: "¥", name: "日元")
    ]
}
