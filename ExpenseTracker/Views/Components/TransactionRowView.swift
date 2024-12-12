import SwiftUI

struct TransactionRowView: View {
    let transaction: Transaction
    
    var body: some View {
        HStack {
            Text(transaction.category.icon)
                .font(.title2)
            
            VStack(alignment: .leading) {
                Text(transaction.category.rawValue)
                    .font(.headline)
                Text(transaction.date, style: .date)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text(amountText)
                .bold()
                .foregroundColor(transaction.type == .expense ? .red : .green)
        }
        .padding(.vertical, 8)
    }
    
    private var amountText: String {
        let prefix = transaction.type == .expense ? "-" : "+"
        return "\(prefix)¥\(String(format: "%.2f", transaction.amount))"
    }
}
