import SwiftUI
import Charts

struct CategoryBreakdownView: View {
    let date: Date
    @EnvironmentObject var store: TransactionStore
    
    struct CategoryTotal: Identifiable {
        let category: Category
        let total: Double
        let percentage: Double
        var id: String { category.rawValue }
    }
    
    var categoryTotals: [CategoryTotal] {
        var totals: [Category: Double] = [:]
        let filtered = filteredTransactions
        let total = filtered.reduce(0) { $0 + $1.amount }
        
        for transaction in filtered {
            totals[transaction.category, default: 0] += transaction.amount
        }
        
        return totals.map {
            CategoryTotal(
                category: $0.key,
                total: $0.value,
                percentage: total > 0 ? ($0.value / total) * 100 : 0
            )
        }.sorted { $0.total > $1.total }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("支出分类".localized())
                .font(.headline)
            
            ForEach(categoryTotals) { category in
                HStack {
                    Text(category.category.icon)
                    Text(category.category.rawValue)
                    Spacer()
                    Text("¥\(category.total, specifier: "%.2f")")
                    Text("(\(category.percentage, specifier: "%.1f")%)")
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 4)
            }
        }
    }
    
    private var filteredTransactions: [Transaction] {
        store.transactions.filter {
            Calendar.current.isDate($0.date, equalTo: date, toGranularity: .month) &&
            $0.type == .expense
        }
    }
}
