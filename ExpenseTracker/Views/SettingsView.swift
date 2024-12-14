import SwiftUI
import StoreKit

struct SettingsView: View {
    @EnvironmentObject var settings: AppSettings
    @EnvironmentObject var store: TransactionStore
    @State private var showingBudgetEditor = false
    @State private var showingResetAlert = false
    @State private var tempBudget: String = ""
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                // 预算设置
                Section {
                    HStack {
                        Label {
                            Text("每月预算".localized())
                        } icon: {
                            Image(systemName: "banknote")
                        }
                        Spacer()
                        Text("\(settings.currency.symbol)\(settings.monthlyBudget, specifier: "%.2f")")
                            .foregroundColor(.secondary)
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        tempBudget = String(format: "%.2f", settings.monthlyBudget)
                        showingBudgetEditor = true
                    }
                } header: {
                    Text("预算管理".localized())
                } footer: {
                    Text("设置每月预算以便更好地管理支出".localized())
                }
                
                // 通用设置
                Section(header: Text("通用设置".localized())) {
                    // 货币设置
                    Picker(selection: $settings.currency) {
                        ForEach(AppSettings.Currency.allCases, id: \.self) { currency in
                            Text("\(currency.displayName) (\(currency.symbol))").tag(currency)
                        }
                    } label: {
                        Label {
                            Text("货币".localized())
                        } icon: {
                            Image(systemName: "creditcard")
                        }
                    }
                    
                    // 语言设置
                    Picker(selection: $settings.language) {
                        ForEach(AppSettings.Language.allCases, id: \.self) { language in
                            Text(language.displayName)
                                .tag(language)
                        }
                    } label: {
                        Label {
                            Text("settings.language".localized())
                        } icon: {
                            Image(systemName: "globe")
                        }
                    }
                    
                    // 通知设置
                    Toggle(isOn: $settings.notificationsEnabled) {
                        Label {
                            Text("预算提醒".localized())
                        } icon: {
                            Image(systemName: "bell.badge")
                        }
                    }
                }
                
                Section(header: Text("自动记账")) {
                    NavigationLink(destination: AutoRecordSettingsView()) {
                        Label("自动记账设置", systemImage: "message")
                    }
                }
                
                Section(header: Text("快捷功能")) {
                    NavigationLink(destination: QuickTransactionListView()) {
                        Label("快捷记账管理", systemImage: "bolt")
                    }
                }
                
                // 数据管理
                Section {
                    // 导出数据
                    ExportDataView()
                    
                    // 清除数据
                    Button(role: .destructive) {
                        showingResetAlert = true
                    } label: {
                        Label {
                            Text("清除所有数据".localized())
                        } icon: {
                            Image(systemName: "trash")
                        }
                    }
                } header: {
                    Text("数据管理".localized())
                } footer: {
                    Text("导出数据将生成CSV文件，可以在其他应用中打开".localized())
                }
                
                // 关于与帮助
                Section {
                    // App Store 评分
                    Button {
                        if let windowScene = UIApplication.shared.windows.first?.windowScene {
                            SKStoreReviewController.requestReview(in: windowScene)
                        }
                    } label: {
                        Label {
                            Text("给个好评".localized())
                        } icon: {
                            Image(systemName: "star")
                        }
                    }
                    
                    // 版本信息
                    HStack {
                        Label {
                            Text("当前版本".localized())
                        } icon: {
                            Image(systemName: "info.circle")
                        }
                        Spacer()
                        Text(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0")
                            .foregroundColor(.secondary)
                    }
                    
                    // 开发者信息
                    HStack {
                        Label {
                            Text("开发者".localized())
                        } icon: {
                            Image(systemName: "person")
                        }
                        Spacer()
                        Text("最爱tyc的wjb")
                            .foregroundColor(.secondary)
                    }
                } header: {
                    Text("关于".localized())
                }
            }
            .navigationTitle("设置".localized())
            .alert("设置预算".localized(), isPresented: $showingBudgetEditor) {
                TextField("输入预算金额".localized(), text: $tempBudget)
                    .keyboardType(.decimalPad)
                Button("取消".localized(), role: .cancel) { }
                Button("确定".localized()) {
                    if let budget = Double(tempBudget) {
                        settings.monthlyBudget = budget
                    }
                }
            }
            .alert("确认清除数据".localized(), isPresented: $showingResetAlert) {
                Button("取消".localized(), role: .cancel) { }
                Button("清除".localized(), role: .destructive) {
                    store.clearAllData()
                    settings.resetToDefault()
                }
            } message: {
                Text("此操作将清除所有交易记录和设置，且无法恢复。确定要继续吗？".localized())
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(AppSettings())
            .environmentObject(TransactionStore())
    }
}
