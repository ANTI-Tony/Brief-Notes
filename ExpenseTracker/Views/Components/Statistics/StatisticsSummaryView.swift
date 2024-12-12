import SwiftUI
import Charts

struct StatisticsSummaryView: View {
    @EnvironmentObject var store: TransactionStore
    let timeRange: StatisticsView.TimeRange
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                StatBox(title: "总支出", value: totalExpenses, textColor: .red)
                StatBox(title: "总收入", value: totalIncome, textColor: .green)
            }
            HStack {
                StatBox(title: "日均支出", value: averageDailyExpense, textColor: .blue)
                StatBox(title: "最大支出", value: maxExpense, textColor: .orange)
            }
        }
    }
    
    private var totalExpenses: Double {
        let filtered = filterTransactions(type: .expense)
        return filtered.reduce(0) { $0 + $1.amount }
    }
    
    private var totalIncome: Double {
        let filtered = filterTransactions(type: .income)
        return filtered.reduce(0) { $0 + $1.amount }
    }
    
    private var averageDailyExpense: Double {
        let days = timeRange == .week ? 7 : (timeRange == .month ? 30 : 365)
        return totalExpenses / Double(days)
    }
    
    private var maxExpense: Double {
        let filtered = filterTransactions(type: .expense)
        return filtered.map { $0.amount }.max() ?? 0
    }
    
    private func filterTransactions(type: TransactionType) -> [Transaction] {
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
            $0.type == type && $0.date >= startDate && $0.date <= now
        }
    }
}
