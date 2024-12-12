import Foundation

struct WidgetData: Codable {
    let totalExpense: Double
    let recentTransactions: [Transaction]
    let lastUpdated: Date
    
    static let preview = WidgetData(
        totalExpense: 1234.56,
        recentTransactions: [],
        lastUpdated: Date()
    )
}
