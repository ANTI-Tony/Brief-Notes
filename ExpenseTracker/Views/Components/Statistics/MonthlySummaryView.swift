import SwiftUI
import Charts

struct MonthlySummaryView: View {
    let date: Date
    @EnvironmentObject var store: TransactionStore
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                StatCard(
                    title: "总支出".localized(),
                    value: totalExpenses,
                    color: .red
                )
                StatCard(
                    title: "总收入".localized(),
                    value: totalIncome,
                    color: .green
                )
            }
            
            HStack {
                StatCard(
                    title: "结余".localized(),
                    value: balance,
                    color: balance >= 0 ? .blue : .red
                )
                StatCard(
                    title: "日均".localized(),
                    value: dailyAverage,
                    color: .orange
                )
            }
        }
    }
    
    private var totalExpenses: Double {
        filterTransactions(type: .expense).reduce(0) { $0 + $1.amount }
    }
    
    private var totalIncome: Double {
        filterTransactions(type: .income).reduce(0) { $0 + $1.amount }
    }
    
    private var balance: Double {
        totalIncome - totalExpenses
    }
    
    private var dailyAverage: Double {
        let daysInMonth = Calendar.current.range(of: .day, in: .month, for: date)?.count ?? 30
        return totalExpenses / Double(daysInMonth)
    }
    
    private func filterTransactions(type: TransactionType) -> [Transaction] {
        store.transactions.filter {
            Calendar.current.isDate($0.date, equalTo: date, toGranularity: .month) &&
            $0.type == type
        }
    }
}
