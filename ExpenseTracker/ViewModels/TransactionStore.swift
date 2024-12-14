import Foundation
import CoreData

class TransactionStore: ObservableObject {
    @Published var transactions: [Transaction] = []
    @Published var currentBudget: Budget?
    
    private let defaults = UserDefaults.standard
    private let transactionsKey = "savedTransactions"
    private let budgetKey = "savedBudget"
    
    init() {
        loadTransactions()
        loadBudget()
    }
    
    func addTransaction(_ transaction: Transaction) {
        transactions.append(transaction)
        saveTransactions()
        print("添加了新交易，当前共有 \(transactions.count) 条记录")
    }
    
    func deleteTransaction(at offsets: IndexSet) {
        transactions.remove(atOffsets: offsets)
        saveTransactions()
    }
    
    func updateBudget(_ budget: Budget) {
        currentBudget = budget
        saveBudget()
    }
    
    func saveTransactions() {
        if let encoded = try? JSONEncoder().encode(transactions) {
            defaults.set(encoded, forKey: transactionsKey)
            defaults.synchronize()
            print("交易数据已保存到 UserDefaults")
        }
    }
    
    private func loadTransactions() {
        if let data = defaults.data(forKey: transactionsKey),
           let decoded = try? JSONDecoder().decode([Transaction].self, from: data) {
            transactions = decoded
            print("从 UserDefaults 加载了 \(transactions.count) 条交易记录")
        }
    }
    
    private func saveBudget() {
        if let budget = currentBudget,
           let encoded = try? JSONEncoder().encode(budget) {
            defaults.set(encoded, forKey: budgetKey)
        }
    }
    
    private func loadBudget() {
        if let data = defaults.data(forKey: budgetKey),
           let decoded = try? JSONDecoder().decode(Budget.self, from: data) {
            currentBudget = decoded
        }
    }
}

extension TransactionStore {
    func clearAllData() {
        transactions.removeAll()
        saveTransactions()
    }
    
    func exportData() -> URL? {
        do {
            return try DataManager.shared.createBackup(transactions: transactions)
        } catch {
            print("Backup failed: \(error.localizedDescription)")
            return nil
        }
    }
    
    func exportCSV() -> URL? {
        do {
            return try DataManager.shared.exportCSV(transactions: transactions)
        } catch {
            print("CSV export failed: \(error.localizedDescription)")
            return nil
        }
    }
    
    func updateTransaction(_ updatedTransaction: Transaction) {
        if let index = transactions.firstIndex(where: { $0.id == updatedTransaction.id }) {
            transactions[index] = updatedTransaction
            saveTransactions()
        }
    }
}
