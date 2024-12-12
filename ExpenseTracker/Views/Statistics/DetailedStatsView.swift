import SwiftUI
import Charts

struct DetailedStatsView: View {
    @EnvironmentObject var store: TransactionStore
    @State private var selectedMonth: Date = Date()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Monthly Selector
                MonthYearPicker(selection: $selectedMonth)
                    .padding()
                
                // Monthly Summary
                MonthlySummaryView(date: selectedMonth)
                    .padding()
                
                // Daily Spending Chart
                DailySpendingChart(date: selectedMonth)
                    .frame(height: 200)
                    .padding()
                
                // Category Breakdown
                CategoryBreakdownView(date: selectedMonth)
                    .padding()
            }
        }
        .navigationTitle("详细统计".localized())
    }
}
