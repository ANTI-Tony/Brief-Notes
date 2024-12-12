// ExpenseTracker/Models/Transaction.swift
import Foundation

struct Transaction: Identifiable, Codable {
    var id: UUID
    var amount: Double
    var type: TransactionType
    var category: Category
    var date: Date
    var note: String?
    
    init(id: UUID = UUID(), amount: Double, type: TransactionType, category: Category, date: Date = Date(), note: String? = nil) {
        self.id = id
        self.amount = amount
        self.type = type
        self.category = category
        self.date = date
        self.note = note
    }
}

enum TransactionType: String, Codable {
    case income
    case expense
}

enum Category: String, Codable, CaseIterable {
    case food = "餐饮"
    case transport = "交通"
    case shopping = "购物"
    case entertainment = "娱乐"
    case health = "医疗"
    case other = "其他"
    
    var icon: String {
        switch self {
        case .food: return "🍱"
        case .transport: return "🚗"
        case .shopping: return "🛍"
        case .entertainment: return "🎮"
        case .health: return "💊"
        case .other: return "📝"
        }
    }
}
