// Views/AutoRecordSettingsView.swift
import SwiftUI

struct AutoRecordSettingsView: View {
    @State private var isSMSRecordEnabled = false
    
    var body: some View {
        Form {
            Section(header: Text("自动记账设置")) {
                Toggle("启用短信自动记账", isOn: $isSMSRecordEnabled)
                    .onChange(of: isSMSRecordEnabled) { newValue in
                        if newValue {
                            SMSManager.shared.requestSMSPermission()
                        }
                    }
                
                if isSMSRecordEnabled {
                    Text("将自动解析微信支付相关短信并记录交易")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Section(header: Text("支持的短信类型")) {
                Label("微信支付收款通知", systemImage: "message.fill")
                Label("微信支付交易通知", systemImage: "message.fill")
            }
            
            Section(header: Text("注意事项")) {
                Text("• 仅支持标准格式的微信支付通知短信")
                Text("• 需要手机收到交易通知短信")
                Text("• 交易分类可能需要手动调整")
            }
            .font(.caption)
        }
        .navigationTitle("自动记账设置")
    }
}
