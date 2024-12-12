import SwiftUI
import Charts

struct DailySpendingChart: View {
    let date: Date
    @EnvironmentObject var store: TransactionStore
    
    struct DailyTotal: Identifiable {
        let day: Int
        let total: Double
        var id: Int { day }
    }
    
    var dailyTotals: [DailyTotal] {
        var totals: [Int: Double] = [:]
        
        for transaction in filteredTransactions {
            let day = Calendar.current.component(.day, from: transaction.date)
            totals[day, default: 0] += transaction.amount
        }
        
        return totals.map { DailyTotal(day: $0.key, total: $0.value) }
            .sorted { $0.day < $1.day }
    }
    
    var body: some View {
        Chart {
            ForEach(dailyTotals) { daily in
                BarMark(
                    x: .value("Day", daily.day),
                    y: .value("Amount", daily.total)
                )
                .foregroundStyle(.blue)
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
