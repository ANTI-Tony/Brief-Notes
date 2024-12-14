import SwiftUI

struct QuickInputView: View {
    @EnvironmentObject var store: TransactionStore
    @EnvironmentObject var quickTransactionStore: QuickTransactionStore
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(quickTransactionStore.quickTransactions) { quickTransaction in
                    Button {
                        addQuickTransaction(quickTransaction)
                    } label: {
                        VStack {
                            Text(quickTransaction.title)
                                .font(.headline)
                            Text(quickTransaction.category.rawValue)
                                .font(.caption)
                            Text("\(quickTransaction.type == .expense ? "-" : "+")\(quickTransaction.amount, specifier: "%.2f")")
                                .foregroundColor(quickTransaction.type == .expense ? .red : .green)
                        }
                        .padding()
                        .frame(minWidth: 80)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(10)
                    }
                }
                
                // 添加快捷方式的按钮
                NavigationLink {
                    QuickTransactionListView()
                } label: {
                    VStack {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                        Text("添加快捷")
                            .font(.caption)
                    }
                    .padding()
                    .frame(minWidth: 80)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                }
            }
            .padding(.horizontal)
        }
    }
    
    private func addQuickTransaction(_ quickTransaction: QuickTransaction) {
        let transaction = Transaction(
            amount: quickTransaction.amount,
            type: quickTransaction.type,
            category: quickTransaction.category,
            note: quickTransaction.note
        )
        
        store.addTransaction(transaction)
    }
}
