import Foundation

class DataManager {
    static let shared = DataManager()
    
    private let fileManager = FileManager.default
    private let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    private init() {}
    
    // 获取备份文件URL
    func getBackupURL() -> URL {
        documentsPath.appendingPathComponent("expense_backup.json")
    }
    
    // 创建备份
    func createBackup(transactions: [Transaction]) throws -> URL {
        let backupURL = getBackupURL()
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = .prettyPrinted
        
        let data = try encoder.encode(transactions)
        try data.write(to: backupURL)
        
        return backupURL
    }
    
    // 从备份恢复
    func restoreFromBackup(url: URL) throws -> [Transaction] {
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        return try decoder.decode([Transaction].self, from: data)
    }
    
    // 导出CSV
    func exportCSV(transactions: [Transaction]) throws -> URL {
        var csvString = "Date,Type,Category,Amount,Note\n"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        
        for transaction in transactions {
            let row = "\(dateFormatter.string(from: transaction.date))," +
                     "\(transaction.type.rawValue)," +
                     "\(transaction.category.rawValue)," +
                     "\(transaction.amount)," +
                     "\"\(transaction.note ?? "")\"\n"
            csvString.append(row)
        }
        
        let csvURL = documentsPath.appendingPathComponent("expenses.csv")
        try csvString.write(to: csvURL, atomically: true, encoding: .utf8)
        
        return csvURL
    }
}
