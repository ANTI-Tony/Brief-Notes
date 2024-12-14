import SwiftUI
import Charts

struct StatisticsView: View {
   @EnvironmentObject var store: TransactionStore
   @State private var selectedTimeRange: TimeRange = .month
   @State private var selectedChartType: ChartType = .category
   
   enum TimeRange {
       case week, month, year
   }
   
   enum ChartType {
       case category, trend
   }
   
   var body: some View {
       NavigationStack {
           VStack(spacing: 16) {
               // Time Range Picker
               Picker("stats.time.range".localized(), selection: $selectedTimeRange) {
                   Text("stats.week".localized()).tag(TimeRange.week)
                   Text("stats.month".localized()).tag(TimeRange.month)
                   Text("stats.year".localized()).tag(TimeRange.year)
               }
               .pickerStyle(.segmented)
               .padding(.horizontal)
               
               // Chart Type Picker
               Picker("stats.chart.type".localized(), selection: $selectedChartType) {
                   Text("stats.chart.category".localized()).tag(ChartType.category)
                   Text("stats.chart.trend".localized()).tag(ChartType.trend)
               }
               .pickerStyle(.segmented)
               .padding(.horizontal)
               
               // Statistics Summary
               StatisticsSummaryView(timeRange: selectedTimeRange)
                   .padding()
               
               // Chart View
               Group {
                   if selectedChartType == .category {
                       CategoryChartView(timeRange: selectedTimeRange)
                   } else {
                       TrendChartView(timeRange: selectedTimeRange)
                   }
               }
               .frame(height: 300)
               .padding()
               
               Spacer()
           }
           .navigationTitle("stats.title".localized())
       }
   }
}
