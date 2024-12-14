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
                Section(header: Text("金额")) {
                    TextField("输入金额", text: $amount)
                        .keyboardType(.decimalPad)
                }
                
                Section(header: Text("类型")) {
                    Picker("类型", selection: $type) {
                        Text("支出").tag(TransactionType.expense)
                        Text("收入").tag(TransactionType.income)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text("分类")) {
                    Picker("分类", selection: $category) {
                        ForEach(Category.allCases, id: \.self) { category in
                            Text("\(category.icon) \(category.rawValue)").tag(category)
                        }
                    }
                }
                
                Section(header: Text("备注")) {
                    TextField("添加备注", text: $note)
                }
            }
            .navigationTitle("新建记录")
            .navigationBarItems(
                leading: Button("取消") { dismiss() },
                trailing: Button("保存") { saveTransaction() }
            )
        }
    }
    
    private func saveTransaction() {
         guard let amountValue = Double(amount) else {
             print("保存失败: 没有解析到金额")
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
