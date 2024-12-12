import SwiftUI

struct HomeView: View {
    @EnvironmentObject var store: TransactionStore
    @State private var showingAddTransaction = false
    
    var body: some View {
        NavigationStack {
            VStack {
                // Budget Summary
                BudgetSummaryView()
                
                // Quick Add Button
                Button(action: { showingAddTransaction = true }) {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .foregroundColor(.blue)
                }
                .padding()
                
                // Recent Transactions List
                TransactionListView()
            }
            .navigationTitle("我的记账本")
            .sheet(isPresented: $showingAddTransaction) {
                AddTransactionView()
            }
        }
    }
}
