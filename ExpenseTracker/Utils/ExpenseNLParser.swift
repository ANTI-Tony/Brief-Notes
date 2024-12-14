import Foundation
import NaturalLanguage

class ExpenseNLParser {
    static let shared = ExpenseNLParser()
    private let tagger: NLTagger
    
    private init() {
        tagger = NLTagger(tagSchemes: [.lexicalClass, .nameType])
    }
    
    func parseExpense(from text: String) -> (amount: Double?, category: Category?, type: TransactionType, note: String?) {
        tagger.string = text
        
        // 金额识别
        let amount = extractAmount(from: text)
        
        // 分类识别
        let category = identifyCategory(from: text)
        
        // 类型识别（收入/支出）
        let type = identifyTransactionType(from: text)
        
        // 提取备注
        let note = extractNote(from: text)
        
        return (amount, category, type, note)
    }
    
    private func extractAmount(from text: String) -> Double? {
        // 预处理文本
        var normalizedText = text
            .replacingOccurrences(of: "块钱", with: "元")
            .replacingOccurrences(of: "块五", with: "5元")
            .replacingOccurrences(of: "两块", with: "2元")
            .replacingOccurrences(of: "一块", with: "1元")
            .replacingOccurrences(of: "十块", with: "10元")
        
        // 添加数字中文转换
        let numberMapping = [
            "一": "1", "二": "2", "三": "3", "四": "4", "五": "5",
            "六": "6", "七": "7", "八": "8", "九": "9", "十": "10"
        ]
        
        for (chinese, arabic) in numberMapping {
            normalizedText = normalizedText.replacingOccurrences(of: chinese + "块", with: arabic + "元")
        }
        
        // 金额匹配模式
        let patterns = [
            ".*?([0-9]+(?:\\.[0-9]+)?)[元块刀].*",            // 带单位的金额
            ".*?([0-9]+(?:\\.[0-9]+)?)(?:块钱|元钱|块|元|刀)",  // 不同单位写法
            ".*?([0-9]+(?:\\.[0-9]+)?)",                     // 纯数字
            ".*[买|花|付|消费].*?([0-9]+(?:\\.[0-9]+)?)"       // 带动词的表达
        ]
        
        for pattern in patterns {
            if let regex = try? NSRegularExpression(pattern: pattern),
               let match = regex.firstMatch(in: normalizedText, range: NSRange(normalizedText.startIndex..., in: normalizedText)),
               let range = Range(match.range(at: 1), in: normalizedText),
               let amount = Double(normalizedText[range]) {
                print("成功识别金额: \(amount)")
                return amount
            }
        }
        
        print("金额识别失败，原文: \(text)")
        return nil
    }
    
    private func identifyCategory(from text: String) -> Category {
        // 分类关键词映射 - 扩充关键词库
        let categoryKeywords: [Category: Set<String>] = [
            .food: ["吃饭", "吃", "饭", "餐", "菜", "水果", "零食", "早餐", "午餐", "晚餐", "夜宵", "外卖", "食堂", "超市", "饮料", "咖啡", "奶茶"],
            .transport: ["车", "地铁", "公交", "出租", "打车", "高铁", "火车", "机票", "的士", "taxi", "滴滴"],
            .shopping: ["买", "购物", "衣服", "裤子", "鞋", "包", "商场", "淘宝", "京东", "购买"],
            .entertainment: ["电影", "游戏", "玩", "唱歌", "KTV", "娱乐", "电玩", "游玩"],
            .health: ["医院", "药", "看病", "体检", "医疗", "诊所", "牙医"],
            .other: []
        ]
        
        var categoryScores: [Category: Int] = [:]
        
        // 优化分类判断逻辑
        for (category, keywords) in categoryKeywords {
            for keyword in keywords {
                if text.contains(keyword) {
                    categoryScores[category, default: 0] += keyword.count // 使用关键词长度作为权重
                }
            }
        }
        
        // 返回得分最高的分类，如果没有匹配则返回 .other
        return categoryScores.max(by: { $0.value < $1.value })?.key ?? .other
    }
    
    private func identifyTransactionType(from text: String) -> TransactionType {
        let incomeKeywords = Set(["收入", "收到", "工资", "工钱", "薪水", "报销", "退款", "红包"])
        
        let tagger = NLTagger(tagSchemes: [.lemma])
        tagger.string = text
        
        var isIncome = false
        tagger.enumerateTags(in: text.startIndex..<text.endIndex, unit: .word, scheme: .lemma) { tag, range in
            let word = String(text[range])
            if incomeKeywords.contains(word) {
                isIncome = true
                return false
            }
            return true
        }
        
        return isIncome ? .income : .expense
    }
    
    private func extractNote(from text: String) -> String? {
        // 移除金额相关的文本
        var note = text
        let amountPatterns = [
            "[0-9]+(?:\\.[0-9]+)?[元块刀]",
            "(?:块钱|元钱|块|元|刀)"
        ]
        
        for pattern in amountPatterns {
            if let regex = try? NSRegularExpression(pattern: pattern) {
                note = regex.stringByReplacingMatches(in: note,
                                                    range: NSRange(note.startIndex..., in: note),
                                                    withTemplate: "")
            }
        }
        
        note = note.trimmingCharacters(in: .whitespacesAndNewlines)
        return note.isEmpty ? nil : note
    }
}
