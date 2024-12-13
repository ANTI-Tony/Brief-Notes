import Foundation
import MessageUI

class AutoRecordMonitor: NSObject {
    static let shared = AutoRecordMonitor()
    private var store: TransactionStore?
    
    func setup(with store: TransactionStore) {
        self.store = store
    }
    
    func startMonitoring() {
        // 注册短信通知监听
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleNewMessage),
            name: NSNotification.Name("SIMSMessageReceivedNotification"),
            object: nil
        )
    }
    
    @objc private func handleNewMessage(notification: Notification) {
        guard let messageText = notification.userInfo?["messageText"] as? String else { return }
        
        if let transaction = SMSManager.shared.parseWeChatPaymentSMS(messageText) {
            DispatchQueue.main.async { [weak self] in
                self?.store?.addTransaction(transaction)
            }
        }
    }
}
