// Views/EditTransactionView.swift
import SwiftUI

struct EditTransactionView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var store: TransactionStore
    
    // 编辑的交易数据
    let transaction: Transaction
    @State private var amount: String
    @State private var type: TransactionType
    @State private var category: Category
    @State private var date: Date
    @State private var note: String
    
    // 初始化编辑数据
    init(transaction: Transaction) {
        self.transaction = transaction
        _amount = State(initialValue: String(format: "%.2f", transaction.amount))
        _type = State(initialValue: transaction.type)
        _category = State(initialValue: transaction.category)
        _date = State(initialValue: transaction.date)
        _note = State(initialValue: transaction.note ?? "")
    }
    
    var body: some View {
        NavigationStack {
            Form {
                // 金额
                Section(header: Text("金额")) {
                    TextField("输入金额", text: $amount)
                        .keyboardType(.decimalPad)
                }
                
                // 类型
                Section(header: Text("类型")) {
                    Picker("类型", selection: $type) {
                        Text("支出").tag(TransactionType.expense)
                        Text("收入").tag(TransactionType.income)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                // 分类
                Section(header: Text("分类")) {
                    Picker("分类", selection: $category) {
                        ForEach(Category.allCases, id: \.self) { category in
                            Text("\(category.icon) \(category.rawValue)").tag(category)
                        }
                    }
                }
                
                // 日期
                Section(header: Text("日期")) {
                    DatePicker("选择日期", selection: $date, displayedComponents: [.date, .hourAndMinute])
                }
                
                // 备注
                Section(header: Text("备注")) {
                    TextField("添加备注", text: $note)
                }
            }
            .navigationTitle("编辑交易")
            .navigationBarItems(
                leading: Button("取消") { dismiss() },
                trailing: Button("保存") { saveChanges() }
            )
        }
    }
    
    private func saveChanges() {
        guard let amountDouble = Double(amount) else { return }
        
        let updatedTransaction = Transaction(
            id: transaction.id, // 保持原有ID
            amount: amountDouble,
            type: type,
            category: category,
            date: date,
            note: note.isEmpty ? nil : note
        )
        
        store.updateTransaction(updatedTransaction)
        dismiss()
    }
}
