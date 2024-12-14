import Foundation

struct QuickTransaction: Identifiable, Codable {
    var id = UUID()
    var title: String       // 显示的标题
    var amount: Double      // 金额
    var category: Category  // 分类
    var type: TransactionType // 收入或支出
    var note: String?      // 备注
}
