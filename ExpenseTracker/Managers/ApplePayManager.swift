// ExpenseTracker/Managers/ApplePayManager.swift
import PassKit

class ApplePayManager: NSObject {
    static let shared = ApplePayManager()
    private var store: TransactionStore?
    
    private override init() {
        super.init()
    }
    
    func setup(with store: TransactionStore) {
        self.store = store
    }
    
    // 检查 Apple Pay 支持
    func checkApplePaySupport() {
        if PKPaymentAuthorizationController.canMakePayments() {
            print("设备支持 Apple Pay")
        } else {
            print("设备不支持 Apple Pay")
        }
    }
    
    // 获取支持的支付网络
    func getSupportedNetworks() -> [PKPaymentNetwork] {
        return [.masterCard, .visa, .amex, .chinaUnionPay]
    }
    
    // 处理新的交易
    func handleNewPayment(amount: Double, note: String? = nil) {
        let transaction = Transaction(
            amount: amount,
            type: .expense,
            category: .shopping,
            date: Date(),
            note: note ?? "Apple Pay 交易"
        )
        
        DispatchQueue.main.async { [weak self] in
            self?.store?.addTransaction(transaction)
        }
    }
}
