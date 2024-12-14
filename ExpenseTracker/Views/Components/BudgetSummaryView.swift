import SwiftUI

struct BudgetSummaryView: View {
    @EnvironmentObject var store: TransactionStore
    @EnvironmentObject var settings: AppSettings
    
    var body: some View {
        VStack(spacing: 10) {
            Text("budget.monthly".localized())
                .font(.headline)
                .foregroundColor(.secondary)
            
            Text("¥\(currentBudgetAmount, specifier: "%.2f")")
                .font(.title)
                .bold()
            
            ProgressView(value: budgetProgress)
                .progressViewStyle(LinearProgressViewStyle(tint: budgetProgressColor))
                .padding(.horizontal)
            
            HStack {
                Text("已支出: ¥\(currentMonthExpenses, specifier: "%.2f")")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Text("剩余: ¥\(remainingBudget, specifier: "%.2f")")
                    .font(.caption)
                    .foregroundColor(remainingBudget >= 0 ? .secondary : .red)
            }
            .padding(.horizontal)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(radius: 2)
    }
    
    // 当月预算金额
    private var currentBudgetAmount: Double {
        settings.monthlyBudget
    }
    
    // 当月已支出金额
    private var currentMonthExpenses: Double {
        let calendar = Calendar.current
        let now = Date()
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: now))!
        let endOfMonth = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth)!
        
        return store.transactions
            .filter { transaction in
                transaction.type == .expense &&
                transaction.date >= startOfMonth &&
                transaction.date <= endOfMonth
            }
            .reduce(0) { $0 + $1.amount }
    }
    
    // 剩余预算
    private var remainingBudget: Double {
        currentBudgetAmount - currentMonthExpenses
    }
    
    // 预算使用进度（0-1之间）
    private var budgetProgress: Double {
        guard currentBudgetAmount > 0 else { return 0 }
        return min(currentMonthExpenses / currentBudgetAmount, 1.0)
    }
    
    // 进度条颜色
    private var budgetProgressColor: Color {
        switch budgetProgress {
        case 0..<0.5:
            return .green // 低于50%显示绿色
        case 0.5..<0.8:
            return .orange // 50%-80%显示橙色
        default:
            return .red // 80%以上显示红色
        }
    }
}

// 预览
struct BudgetSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        BudgetSummaryView()
            .environmentObject(TransactionStore())
            .environmentObject(AppSettings())
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
