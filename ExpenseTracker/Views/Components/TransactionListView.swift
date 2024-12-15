import SwiftUI

struct TransactionListView: View {
    @EnvironmentObject var store: TransactionStore
    @State private var editingTransaction: Transaction? = nil
    
    var body: some View {
        List {
            ForEach(store.transactions) { transaction in
                TransactionRowView(transaction: transaction)
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            if let index = store.transactions.firstIndex(where: { $0.id == transaction.id }) {
                                store.transactions.remove(at: index)
                                store.saveTransactions()
                            }
                        } label: {
                            Label("action.delete".localized(), systemImage: "trash")
                        }
                        
                        Button {
                            editingTransaction = transaction
                        } label: {
                            Label("action.edit".localized(), systemImage: "pencil")
                        }
                        .tint(.blue)
                    }
            }
        }
        .sheet(item: $editingTransaction) { transaction in
            EditTransactionView(transaction: transaction)
        }
    }
}
