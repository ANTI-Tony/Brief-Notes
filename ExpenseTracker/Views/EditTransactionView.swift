import SwiftUI

struct EditTransactionView: View {
   @Environment(\.dismiss) private var dismiss
   @EnvironmentObject var store: TransactionStore
   
   let transaction: Transaction
   @State private var amount: String
   @State private var type: TransactionType
   @State private var category: Category
   @State private var date: Date
   @State private var note: String
   
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
               Section(header: Text("transaction.amount".localized())) {
                   TextField("transaction.amount.input".localized(), text: $amount)
                       .keyboardType(.decimalPad)
               }
               
               // 类型
               Section(header: Text("transaction.type".localized())) {
                   Picker("transaction.type".localized(), selection: $type) {
                       Text("transaction.expense".localized()).tag(TransactionType.expense)
                       Text("transaction.income".localized()).tag(TransactionType.income)
                   }
                   .pickerStyle(SegmentedPickerStyle())
               }
               
               // 分类
               Section(header: Text("transaction.category".localized())) {
                   Picker("transaction.category".localized(), selection: $category) {
                       ForEach(Category.allCases, id: \.self) { category in
                           Text("\(category.icon) \(category.rawValue)").tag(category)
                       }
                   }
               }
               
               // 日期
               Section(header: Text("transaction.date".localized())) {
                   DatePicker("transaction.date.select".localized(),
                            selection: $date,
                            displayedComponents: [.date, .hourAndMinute])
               }
               
               // 备注
               Section(header: Text("transaction.note".localized())) {
                   TextField("transaction.note.input".localized(), text: $note)
               }
           }
           .navigationTitle("transaction.edit".localized())
           .navigationBarItems(
               leading: Button("action.cancel".localized()) { dismiss() },
               trailing: Button("action.save".localized()) { saveChanges() }
           )
       }
   }
   
   private func saveChanges() {
       guard let amountDouble = Double(amount) else { return }
       
       let updatedTransaction = Transaction(
           id: transaction.id,
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
