import SwiftUI

struct EditQuickTransactionView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var quickTransactionStore: QuickTransactionStore
    
    @State private var title: String
    @State private var amount: String
    @State private var category: Category
    @State private var type: TransactionType
    @State private var note: String
    
    let quickTransaction: QuickTransaction?
    
    init(quickTransaction: QuickTransaction? = nil) {
        self.quickTransaction = quickTransaction
        _title = State(initialValue: quickTransaction?.title ?? "")
        _amount = State(initialValue: quickTransaction?.amount.description ?? "")
        _category = State(initialValue: quickTransaction?.category ?? .other)
        _type = State(initialValue: quickTransaction?.type ?? .expense)
        _note = State(initialValue: quickTransaction?.note ?? "")
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("基本信息")) {
                    TextField("标题", text: $title)
                    TextField("金额", text: $amount)
                        .keyboardType(.decimalPad)
                    
                    Picker("类型", selection: $type) {
                        Text("支出").tag(TransactionType.expense)
                        Text("收入").tag(TransactionType.income)
                    }
                    
                    Picker("分类", selection: $category) {
                        ForEach(Category.allCases, id: \.self) { category in
                            Text(category.rawValue).tag(category)
                        }
                    }
                }
                
                Section(header: Text("备注")) {
                    TextField("备注（可选）", text: $note)
                }
            }
            .navigationTitle(quickTransaction == nil ? "新建快捷记账" : "编辑快捷记账")
            .navigationBarItems(
                leading: Button("取消") { dismiss() },
                trailing: Button("保存") { saveQuickTransaction() }
            )
        }
    }
    
    private func saveQuickTransaction() {
        guard let amountValue = Double(amount) else { return }
        
        let newQuickTransaction = QuickTransaction(
            id: quickTransaction?.id ?? UUID(),
            title: title,
            amount: amountValue,
            category: category,
            type: type,
            note: note.isEmpty ? nil : note
        )
        
        if quickTransaction != nil {
            quickTransactionStore.updateQuickTransaction(newQuickTransaction)
        } else {
            quickTransactionStore.addQuickTransaction(newQuickTransaction)
        }
        
        dismiss()
    }
}
