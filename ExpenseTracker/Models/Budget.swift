import Foundation

struct Budget: Codable {
    var amount: Double
    var startDate: Date
    var endDate: Date
    var category: Category?
}
