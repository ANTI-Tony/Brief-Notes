import Foundation

class QuickTransactionStore: ObservableObject {
    @Published var quickTransactions: [QuickTransaction] = []
    private let defaults = UserDefaults.standard
    private let quickTransactionsKey = "savedQuickTransactions"
    
    init() {
        loadQuickTransactions()
    }
    
    func addQuickTransaction(_ transaction: QuickTransaction) {
        quickTransactions.append(transaction)
        saveQuickTransactions()
    }
    
    func updateQuickTransaction(_ transaction: QuickTransaction) {
        if let index = quickTransactions.firstIndex(where: { $0.id == transaction.id }) {
            quickTransactions[index] = transaction
            saveQuickTransactions()
        }
    }
    
    func deleteQuickTransaction(_ transaction: QuickTransaction) {
        quickTransactions.removeAll { $0.id == transaction.id }
        saveQuickTransactions()
    }
    
    private func saveQuickTransactions() {
        if let encoded = try? JSONEncoder().encode(quickTransactions) {
            defaults.set(encoded, forKey: quickTransactionsKey)
        }
    }
    
    private func loadQuickTransactions() {
        if let data = defaults.data(forKey: quickTransactionsKey),
           let decoded = try? JSONDecoder().decode([QuickTransaction].self, from: data) {
            quickTransactions = decoded
        }
    }
}
