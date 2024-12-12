import SwiftUI
import UniformTypeIdentifiers

struct ExportDataView: View {
    @EnvironmentObject var store: TransactionStore
    @State private var showingShare = false
    @State private var exportData: String = ""
    
    var body: some View {
        Button(action: prepareAndExportData) {
            Label {
                Text("settings.export_data".localized())
            } icon: {
                Image(systemName: "square.and.arrow.up")
            }
        }
        .sheet(isPresented: $showingShare) {
            ShareSheet(activityItems: [exportData])
        }
    }
    
    private func prepareAndExportData() {
        var csvString = "Date,Type,Category,Amount,Note\n"
        
        for transaction in store.transactions {
            let row = "\(dateFormatter.string(from: transaction.date))," +
                     "\(transaction.type.rawValue)," +
                     "\(transaction.category.rawValue)," +
                     "\(transaction.amount)," +
                     "\(transaction.note ?? "")\n"
            csvString.append(row)
        }
        
        exportData = csvString
        showingShare = true
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
}
