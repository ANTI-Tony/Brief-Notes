import SwiftUI
import Charts

struct CategoryChartView: View {
    @EnvironmentObject var store: TransactionStore
    let timeRange: StatisticsView.TimeRange
    
    struct CategorySum: Identifiable {
        let category: Category
        let amount: Double
        var id: String { category.rawValue }
    }
    
    var categoryData: [CategorySum] {
        let filtered = filterTransactions()
        var sums: [Category: Double] = [:]
        
        for transaction in filtered {
            sums[transaction.category, default: 0] += transaction.amount
        }
        
        return sums.map { CategorySum(category: $0.key, amount: $0.value) }
            .sorted { $0.amount > $1.amount }
    }
    
    var body: some View {
        Chart {
            ForEach(categoryData) { item in
                SectorMark(
                    angle: .value("金额", item.amount),
                    innerRadius: .ratio(0.6),
                    angularInset: 1.5
                )
                .foregroundStyle(by: .value("分类", item.category.rawValue))
                .annotation(position: .overlay) {
                    Text("\(Int(item.amount / totalAmount * 100))%")
                        .font(.caption)
                        .foregroundColor(.white)
                }
            }
        }
    }
    
    private var totalAmount: Double {
        categoryData.reduce(0) { $0 + $1.amount }
    }
    
    private func filterTransactions() -> [Transaction] {
        let calendar = Calendar.current
        let now = Date()
        let startDate: Date
        
        switch timeRange {
        case .week:
            startDate = calendar.date(byAdding: .day, value: -7, to: now)!
        case .month:
            startDate = calendar.date(byAdding: .month, value: -1, to: now)!
        case .year:
            startDate = calendar.date(byAdding: .year, value: -1, to: now)!
        }
        
        return store.transactions.filter {
            $0.type == .expense && $0.date >= startDate && $0.date <= now
        }
    }
}
