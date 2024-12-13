import SwiftUI

struct QuickInputView: View {
    @EnvironmentObject var store: TransactionStore
    @State private var quickInputs: [QuickInput] = [
        QuickInput(amount: 5, category: .food, note: "早餐"),
        QuickInput(amount: 20, category: .transport, note: "公交")
    ]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(quickInputs) { input in
                    Button {
                        addQuickTransaction(input)
                    } label: {
                        VStack {
                            Text(input.category.icon)
                                .font(.title2)
                            Text("\(input.amount, specifier: "%.2f")")
                                .bold()
                            if let note = input.note {
                                Text(note)
                                    .font(.caption)
                            }
                        }
                        .padding()
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(10)
                    }
                }
            }
            .padding()
        }
    }
    
    private func addQuickTransaction(_ input: QuickInput) {
        let transaction = Transaction(
            amount: input.amount,
            type: .expense,
            category: input.category,
            note: input.note
        )
        store.addTransaction(transaction)
    }
}
