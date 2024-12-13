import Foundation

struct QuickInput: Identifiable, Codable {
    var id = UUID() // 修正 UUID 错误
    let amount: Double
    let category: Category
    let note: String?
    
    init(id: UUID = UUID(), amount: Double, category: Category, note: String? = nil) {
        self.id = id
        self.amount = amount
        self.category = category
        self.note = note
    }
}
