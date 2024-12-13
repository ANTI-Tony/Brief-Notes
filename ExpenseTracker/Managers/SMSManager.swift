import Foundation
import MessageUI

class SMSManager: NSObject {
    static let shared = SMSManager()
    
    func requestSMSPermission() {
        // 检查短信权限
        if #available(iOS 11.0, *) {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
                if granted {
                    print("短信权限获取成功")
                } else {
                    print("短信权限获取失败")
                }
            }
        }
    }
    
    // 解析微信支付短信
    func parseWeChatPaymentSMS(_ messageText: String) -> Transaction? {
        // 微信支付短信模式匹配
        // 例如：微信支付收款(尾号0000)：支付宝支付了0.01元。
        let patterns = [
            "微信支付收款.*?支付了(\\d+\\.?\\d*)元",
            "微信支付.*?收款(\\d+\\.?\\d*)元"
        ]
        
        for pattern in patterns {
            if let regex = try? NSRegularExpression(pattern: pattern, options: []),
               let match = regex.firstMatch(in: messageText, options: [], range: NSRange(messageText.startIndex..., in: messageText)) {
                
                if let amountRange = Range(match.range(at: 1), in: messageText),
                   let amount = Double(messageText[amountRange]) {
                    
                    return Transaction(
                        amount: amount,
                        type: .income,
                        category: .other,
                        note: "微信支付收款"
                    )
                }
            }
        }
        return nil
    }
}
