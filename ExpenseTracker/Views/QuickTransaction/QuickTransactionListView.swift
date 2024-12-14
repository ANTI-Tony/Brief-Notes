import SwiftUI

struct QuickTransactionListView: View {
    @EnvironmentObject var quickTransactionStore: QuickTransactionStore
    @State private var showingAddSheet = false
    @State private var editingTransaction: QuickTransaction? = nil
    
    var body: some View {
        List {
            ForEach(quickTransactionStore.quickTransactions) { transaction in
                QuickTransactionRow(transaction: transaction)
                    .onTapGesture {
                        editingTransaction = transaction
                    }
            }
            .onDelete { indexSet in
                indexSet.forEach { index in
                    quickTransactionStore.deleteQuickTransaction(quickTransactionStore.quickTransactions[index])
                }
            }
        }
        .navigationTitle("快捷记账管理")
        .toolbar {
            Button {
                showingAddSheet = true
            } label: {
                Image(systemName: "plus")
            }
        }
        .sheet(isPresented: $showingAddSheet) {
            EditQuickTransactionView()
        }
        .sheet(item: $editingTransaction) { transaction in
            EditQuickTransactionView(quickTransaction: transaction)
        }
    }
}

struct QuickTransactionRow: View {
    let transaction: QuickTransaction
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(transaction.title)
                    .font(.headline)
                Text(transaction.category.rawValue)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text("\(transaction.type == .expense ? "-" : "+")\(transaction.amount, specifier: "%.2f")")
                .foregroundColor(transaction.type == .expense ? .red : .green)
        }
    }
}
