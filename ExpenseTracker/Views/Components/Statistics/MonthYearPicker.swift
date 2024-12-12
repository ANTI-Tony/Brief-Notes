import SwiftUI
import Charts

struct MonthYearPicker: View {
    @Binding var selection: Date
    
    var body: some View {
        HStack {
            Button(action: previousMonth) {
                Image(systemName: "chevron.left")
            }
            
            Text(selection, formatter: monthYearFormatter)
                .font(.headline)
            
            Button(action: nextMonth) {
                Image(systemName: "chevron.right")
            }
        }
    }
    
    private func previousMonth() {
        if let newDate = Calendar.current.date(byAdding: .month, value: -1, to: selection) {
            selection = newDate
        }
    }
    
    private func nextMonth() {
        if let newDate = Calendar.current.date(byAdding: .month, value: 1, to: selection) {
            selection = newDate
        }
    }
    
    private let monthYearFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月"
        return formatter
    }()
}
