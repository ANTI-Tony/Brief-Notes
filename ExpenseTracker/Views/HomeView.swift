import SwiftUI

struct HomeView: View {
    @EnvironmentObject var store: TransactionStore
    @State private var showingAddTransaction = false
    @State private var showingVoiceInput = false // 添加语音输入状态
    
    var body: some View {
        NavigationStack {
            VStack {
                // 预算概览
                BudgetSummaryView()
                
                // 添加快捷输入栏
                QuickInputView()
                
                // 快速添加按钮
                Button(action: { showingAddTransaction = true }) {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .foregroundColor(.blue)
                }
                .padding()
                
                // 交易列表
                TransactionListView()
            }
            .navigationTitle("我的记账本".localized())
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingVoiceInput = true
                    } label: {
                        Image(systemName: "mic.circle.fill")
                            .font(.title2)
                    }
                }
            }
            .sheet(isPresented: $showingAddTransaction) {
                AddTransactionView()
            }
            .sheet(isPresented: $showingVoiceInput) {
                VoiceInputView(isPresented: $showingVoiceInput)
            }
        }
    }
}

