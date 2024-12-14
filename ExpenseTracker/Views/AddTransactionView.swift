import SwiftUI

struct AddTransactionView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var store: TransactionStore
    
    @State private var amount: String = ""
    @State private var type: TransactionType = .expense
    @State private var category: Category = .other
    @State private var note: String = ""
    @State private var isPresented = true
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("transaction.amount".localized())) {
                    TextField("transaction.amount.input".localized(), text: $amount)
                        .keyboardType(.decimalPad)
                }
                
                Section(header: Text("transaction.type".localized())) {
                    Picker("transaction.type".localized(), selection: $type) {
                        Text("transaction.expense".localized()).tag(TransactionType.expense)
                        Text("transaction.income".localized()).tag(TransactionType.income)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text("transaction.category".localized())) {
                    Picker("transaction.category".localized(), selection: $category) {
                        ForEach(Category.allCases, id: \.self) { category in
                            Text("\(category.icon) \(category.rawValue)").tag(category)
                        }
                    }
                }
                
                Section(header: Text("transaction.note".localized())) {
                    TextField("transaction.note.input".localized(), text: $note)
                }
            }
            .navigationTitle("transaction.new".localized())
            .navigationBarItems(
                leading: Button("action.cancel".localized()) { dismiss() },
                trailing: Button("action.save".localized()) { saveTransaction() }
            )
        }
    }
    
    private func saveTransaction() {
        guard let amountValue = Double(amount) else {
            print("transaction.save.failed".localized())
            return
        }
        
        let transaction = Transaction(
            amount: amountValue,
            type: type,
            category: category,
            note: note.isEmpty ? nil : note
        )
        
        store.addTransaction(transaction)
        
        withAnimation {
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isPresented = false
                dismiss()
            }
        }
    }
}
