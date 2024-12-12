import SwiftUI
import Charts

struct TrendChartView: View {
    @EnvironmentObject var store: TransactionStore
    let timeRange: StatisticsView.TimeRange
    
    struct DailySum: Identifiable {
        let date: Date
        let amount: Double
        var id: Date { date }
    }
    
    var trendData: [DailySum] {
        let filtered = filterTransactions()
        var sums: [Date: Double] = [:]
        
        for transaction in filtered {
            let date = Calendar.current.startOfDay(for: transaction.date)
            sums[date, default: 0] += transaction.amount
        }
        
        return sums.map { DailySum(date: $0.key, amount: $0.value) }
            .sorted { $0.date < $1.date }
    }
    
    var body: some View {
        Chart {
            ForEach(trendData) { item in
                LineMark(
                    x: .value("日期", item.date),
                    y: .value("金额", item.amount)
                )
                PointMark(
                    x: .value("日期", item.date),
                    y: .value("金额", item.amount)
                )
            }
        }
        .chartXAxis {
            AxisMarks(values: .stride(by: .day, count: timeRange == .week ? 1 : 7)) { value in
                if let date = value.as(Date.self) {
                    AxisValueLabel(format: .dateTime.day())
                }
            }
        }
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
