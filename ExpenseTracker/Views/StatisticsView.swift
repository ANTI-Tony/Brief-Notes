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
                Picker("时间范围", selection: $selectedTimeRange) {
                    Text("本周").tag(TimeRange.week)
                    Text("本月").tag(TimeRange.month)
                    Text("今年").tag(TimeRange.year)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                
                // Chart Type Picker
                Picker("图表类型", selection: $selectedChartType) {
                    Text("分类统计").tag(ChartType.category)
                    Text("趋势分析").tag(ChartType.trend)
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
            .navigationTitle("支出统计")
        }
    }
}
