import SwiftUI
import Speech

struct VoiceInputView: View {
    @EnvironmentObject var store: TransactionStore
    @Binding var isPresented: Bool
    
    @State private var isRecording = false
    @State private var recognizedText = ""
    @State private var parsedAmount: Double?
    @State private var parsedCategory: Category?
    @State private var parsedType: TransactionType = .expense
    @State private var parsedNote: String?
    @State private var showingSaveSuccess = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text(recognizedText)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.secondary.opacity(0.1))
                    .cornerRadius(10)
                
                // 录音按钮
                Button {
                    toggleRecording()
                } label: {
                    Image(systemName: isRecording ? "stop.circle.fill" : "mic.circle.fill")
                        .font(.system(size: 64))
                        .foregroundColor(isRecording ? .red : .blue)
                }
                
                // 显示解析结果
                VStack(alignment: .leading, spacing: 10) {
                    if let amount = parsedAmount {
                        Text("金额: ¥\(amount, specifier: "%.2f")")
                    }
                    
                    if let category = parsedCategory {
                        Text("分类: \(category.rawValue)")
                    }
                    
                    Text("类型: \(parsedType == .expense ? "支出" : "收入")")
                    
                    if let note = parsedNote {
                        Text("备注: \(note)")
                    }
                }
                .padding()
                
                Spacer()
                
                if !recognizedText.isEmpty {
                    Button("保存") {
                        saveTransaction()
                        showingSaveSuccess = true
                    }
                    .buttonStyle(.borderedProminent)
                    .padding()
                }
            }
            .padding()
            .navigationTitle("语音记账")
            .navigationBarItems(
                leading: Button("取消") {
                    isPresented = false
                }
            )
            .overlay {
                if showingSaveSuccess {
                    Text("保存成功")
                        .padding()
                        .background(Color.green.opacity(0.2))
                        .cornerRadius(10)
                        .transition(.scale.combined(with: .opacity))
                }
            }
        }
    }
   
    private func toggleRecording() {
        if isRecording {
            SpeechManager.shared.stopRecording()
            isRecording = false
        } else {
            SpeechManager.shared.startRecording { text in
                DispatchQueue.main.async {
                    self.recognizedText = text
                    self.parseVoiceInput(text)
                }
            }
            isRecording = true
        }
    }
   
   private func parseVoiceInput(_ text: String) {
       let result = ExpenseNLParser.shared.parseExpense(from: text)
       parsedAmount = result.amount
       parsedCategory = result.category
       parsedType = result.type
       parsedNote = result.note
   }
   
    private func saveTransaction() {
        guard let amount = parsedAmount else {
            return
        }
        
        let transaction = Transaction(
            amount: amount,
            type: parsedType,
            category: parsedCategory ?? .other,
            note: parsedNote ?? recognizedText
        )

        store.addTransaction(transaction)
        store.saveTransactions()

        // 添加成功提示和关闭
        withAnimation {
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isPresented = false
            }
        }
    }
}
