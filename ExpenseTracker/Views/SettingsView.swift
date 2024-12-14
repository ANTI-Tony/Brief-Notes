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
                            Text("settings.monthly.budget".localized())
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
                    Text("settings.budget.management".localized())
                } footer: {
                    Text("settings.budget.description".localized())
                }
                
                // 通用设置
                Section(header: Text("settings.general".localized())) {
                    // 货币设置
                    Picker(selection: $settings.currency) {
                        ForEach(AppSettings.Currency.allCases, id: \.self) { currency in
                            Text("\(currency.displayName) (\(currency.symbol))").tag(currency)
                        }
                    } label: {
                        Label {
                            Text("settings.currency".localized())
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
                            Text("settings.notifications".localized())
                        } icon: {
                            Image(systemName: "bell.badge")
                        }
                    }
                }
                
                Section(header: Text("settings.auto.record".localized())) {
                    NavigationLink(destination: AutoRecordSettingsView()) {
                        Label("settings.auto.record.settings".localized(), systemImage: "message")
                    }
                }

                Section(header: Text("settings.quick.actions".localized())) {
                    NavigationLink(destination: QuickTransactionListView()) {
                        Label("settings.quick.transaction.management".localized(), systemImage: "bolt")
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
                            Text("settings.clear.all.data".localized())
                        } icon: {
                            Image(systemName: "trash")
                        }
                    }
                } header: {
                    Text("settings.data.management".localized())
                } footer: {
                    Text("settings.export.data.description".localized())
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
                            Text("settings.rate.us".localized())
                        } icon: {
                            Image(systemName: "star")
                        }
                    }
                    
                    // 版本信息
                    HStack {
                        Label {
                            Text("settings.current.version".localized())
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
                            Text("settings.developer".localized())
                        } icon: {
                            Image(systemName: "person")
                        }
                        Spacer()
                        Text("settings.developer.name".localized())
                            .foregroundColor(.secondary)
                    }
                } header: {
                    Text("settings.about".localized())
                }
            }
            .navigationTitle("settings.title".localized())
            .alert("settings.budget.title".localized(), isPresented: $showingBudgetEditor) {
                TextField("settings.budget.input".localized(), text: $tempBudget)
                    .keyboardType(.decimalPad)
                Button("action.cancel".localized(), role: .cancel) { }
                Button("action.confirm".localized()) {
                    if let budget = Double(tempBudget) {
                        settings.monthlyBudget = budget
                    }
                }
            }
            .alert("settings.clear.confirm".localized(), isPresented: $showingResetAlert) {
                Button("action.cancel".localized(), role: .cancel) { }
                Button("action.clear".localized(), role: .destructive) {
                    store.clearAllData()
                    settings.resetToDefault()
                }
            } message: {
                Text("settings.clear.message".localized())
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
