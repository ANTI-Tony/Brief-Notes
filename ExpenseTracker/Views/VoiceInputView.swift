// Views/VoiceInputView.swift
import SwiftUI
import Speech

struct VoiceInputView: View {
    @EnvironmentObject var store: TransactionStore
    @Binding var isPresented: Bool
    
    @State private var isRecording = false
    @State private var recognizedText = ""
    @State private var parsedAmount: Double?
    @State private var parsedCategory: Category?
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text(recognizedText)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.secondary.opacity(0.1))
                    .cornerRadius(10)
                
                Button {
                    toggleRecording()
                } label: {
                    Image(systemName: isRecording ? "stop.circle.fill" : "mic.circle.fill")
                        .font(.system(size: 64))
                        .foregroundColor(isRecording ? .red : .blue)
                }
                
                if let amount = parsedAmount {
                    Text("识别金额: ¥\(amount, specifier: "%.2f")")
                }
                
                if let category = parsedCategory {
                    Text("识别分类: \(category.rawValue)")
                }
                
                if parsedAmount != nil {
                    Button("保存") {
                        saveTransaction()
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .padding()
            .navigationTitle("语音记账")
            .navigationBarItems(
                leading: Button("取消") {
                    isPresented = false
                }
            )
        }
    }
    
    private func toggleRecording() {
        if isRecording {
            SpeechManager.shared.stopRecording()
        } else {
            SpeechManager.shared.startRecording { text in
                self.recognizedText = text
                parseVoiceInput(text)
            }
        }
        isRecording.toggle()
    }
    
    private func parseVoiceInput(_ text: String) {
        // 解析金额
        let patterns = [
            ".*花了(\\d+(\\.\\d+)?).*",
            ".*支付(\\d+(\\.\\d+)?).*",
            "(\\d+(\\.\\d+)?)元.*"
        ]
        
        for pattern in patterns {
            if let regex = try? NSRegularExpression(pattern: pattern),
               let match = regex.firstMatch(in: text, range: NSRange(text.startIndex..., in: text)),
               let range = Range(match.range(at: 1), in: text) {
                parsedAmount = Double(text[range])
                break
            }
        }
        
        // 解析分类
        for category in Category.allCases {
            if text.contains(category.rawValue) {
                parsedCategory = category
                break
            }
        }
    }
    
    private func saveTransaction() {
        guard let amount = parsedAmount else { return }
        
        let transaction = Transaction(
            amount: amount,
            type: .expense,
            category: parsedCategory ?? .other,
            note: recognizedText
        )
        
        store.addTransaction(transaction)
        isPresented = false
    }
}
