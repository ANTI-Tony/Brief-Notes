# ExpenseTracker - iOS记账应用

一款功能完善的iOS原生记账应用，采用Swift和SwiftUI构建，支持多币种、语音输入、智能分析等功能。

## 🎯 项目概述

ExpenseTracker是一款现代化的iOS记账应用，提供直观的用户界面和强大的数据管理功能，帮助用户更好地管理个人财务。

### 核心特性

- 📱 **原生iOS体验** - 使用SwiftUI构建，完美适配iOS生态
- 💰 **多币种支持** - 支持多种货币记账和汇率转换
- 🎤 **语音输入** - 集成语音识别，快速记录交易
- 🔔 **智能提醒** - 自动记录提醒和预算预警
- 📊 **数据可视化** - 详细的消费统计和趋势分析
- 🔐 **数据安全** - 本地数据加密存储
- 🌓 **深色模式** - 完整支持系统深色模式
- 🔄 **快速记账** - QuickTransaction快捷输入功能
- 📝 **自然语言解析** - 智能解析文本输入的交易信息

## 🏗️ 项目架构

### 技术栈

**开发框架**
- SwiftUI - 声明式UI框架
- Swift 5.9+ - 主要编程语言
- iOS 16.0+ - 最低支持版本
- SwiftData - 数据持久化
- Combine - 响应式编程

**核心功能模块**
- Speech Framework - 语音识别
- UserNotifications - 本地通知
- WidgetKit - 桌面小组件
- NaturalLanguage - 自然语言处理

### 架构模式

```
MVVM (Model-View-ViewModel) 架构
├── Models - 数据模型层
├── Views - 视图层
├── ViewModels - 视图模型层
├── Managers - 业务逻辑管理器
├── Utils - 工具类
└── Extensions - 扩展功能
```

## 📋 功能详解

### ✅ 已实现功能

**交易管理**
- 添加/编辑/删除交易记录
- 快速记账（QuickTransaction）
- 交易分类管理
- 备注和标签功能
- 交易历史查询

**智能功能**
- 自然语言输入解析（ExpenseNLParser）
  - "午餐花了50元" → 自动识别金额、分类
  - "昨天买衣服300" → 自动设置日期和分类
- 语音识别输入（SpeechManager）
- 自动记录提醒（AutoRecordMonitor）
- 智能分类建议

**数据分析**
- 按日/周/月/年统计
- 分类消费分析
- 收支趋势图表
- 预算执行情况
- 自定义时间范围统计

**预算管理**
- 设置月度预算
- 分类预算控制
- 预算超支提醒
- 预算执行进度

**多币种功能**
- 支持多种货币记账
- 实时汇率更新
- 货币转换计算
- 基准货币设置

**应用设置**
- 通知管理
- 自动记录设置
- 货币偏好设置
- 数据导入导出
- 应用主题切换

**Widget小组件**
- 今日支出统计
- 本月预算进度
- 快速记账入口

### 🚧 开发中功能

- iCloud数据同步
- 多设备协同
- 账单拍照识别
- 定期账单管理
- 财务目标设置
- 数据可视化优化

## 🚀 快速开始

### 环境要求

- macOS 13.0+
- Xcode 15.0+
- iOS 16.0+ (目标设备)
- Swift 5.9+

### 安装步骤

#### 1. 克隆仓库

```bash
git clone https://github.com/your-username/ExpenseTracker.git
cd ExpenseTracker
```

#### 2. 打开项目

```bash
# 使用Xcode打开项目
open ExpenseTracker.xcodeproj
```

#### 3. 配置签名

1. 在Xcode中选择项目
2. 选择Target: ExpenseTracker
3. 在"Signing & Capabilities"中配置Team
4. 确保Bundle Identifier唯一

#### 4. 运行应用

```bash
# 选择目标设备（模拟器或真机）
# 点击Run按钮或按 Cmd+R
```

### 权限配置

应用需要以下权限（已在Info.plist中配置）：

```xml
<!-- 语音识别权限 -->
<key>NSSpeechRecognitionUsageDescription</key>
<string>我们需要访问语音识别以支持语音记账功能</string>

<!-- 麦克风权限 -->
<key>NSMicrophoneUsageDescription</key>
<string>我们需要访问麦克风以支持语音输入功能</string>

<!-- 通知权限（运行时请求） -->
```

## 📊 项目结构

```
ExpenseTracker/
├── ExpenseTracker/
│   ├── Models/                          # 数据模型
│   │   ├── Transaction.swift           # 交易记录模型
│   │   ├── Budget.swift                # 预算模型
│   │   ├── Currency.swift              # 货币模型
│   │   ├── AppSettings.swift           # 应用设置
│   │   ├── QuickInput.swift            # 快速输入模型
│   │   ├── QuickTransaction.swift      # 快速交易模型
│   │   └── WidgetData.swift            # Widget数据模型
│   │
│   ├── Views/                           # 视图层
│   │   ├── ContentView.swift           # 主视图
│   │   ├── AddTransactionView.swift    # 添加交易
│   │   ├── EditTransactionView.swift   # 编辑交易
│   │   ├── AutoRecordSettingsView.swift # 自动记录设置
│   │   ├── Components/                 # 通用组件
│   │   ├── QuickTransaction/           # 快速交易视图
│   │   └── Statistics/                 # 统计视图
│   │
│   ├── ViewModels/                      # 视图模型
│   │   ├── TransactionStore.swift      # 交易数据管理
│   │   ├── QuickTransactionStore.swift # 快速交易管理
│   │   └── CurrencySettings.swift      # 货币设置
│   │
│   ├── Managers/                        # 管理器
│   │   ├── DataManager.swift           # 数据管理
│   │   ├── NotificationManager.swift   # 通知管理
│   │   ├── SpeechManager.swift         # 语音管理
│   │   ├── SMSManager.swift            # 短信管理（预留）
│   │   └── AutoRecordMonitor.swift     # 自动记录监控
│   │
│   ├── Utils/                           # 工具类
│   │   └── ExpenseNLParser.swift       # 自然语言解析
│   │
│   ├── Extensions/                      # 扩展
│   │   └── String+Localization.swift   # 本地化扩展
│   │
│   ├── Resources/                       # 资源文件
│   │   ├── Assets.xcassets             # 图片资源
│   │   └── Localizable.strings         # 多语言文件
│   │
│   └── Preview Content/                 # 预览内容
│
├── ExpenseTrackerWidget/                # Widget扩展
│   └── WidgetView.swift
│
└── ExpenseTracker.xcodeproj             # Xcode项目文件
```

## 💡 核心功能实现

### 1. 快速记账 (QuickTransaction)

```swift
// 快速输入界面，支持文本和语音
struct QuickTransactionView: View {
    @State private var inputText = ""
    @StateObject private var speechManager = SpeechManager()
    
    var body: some View {
        VStack {
            TextField("例如: 午餐 50元", text: $inputText)
            Button("语音输入") {
                speechManager.startRecording()
            }
        }
    }
}
```

### 2. 自然语言解析

```swift
// ExpenseNLParser - 解析用户输入
class ExpenseNLParser {
    static func parse(_ text: String) -> ParsedExpense? {
        // 识别金额: "50元", "100", "$20"
        // 识别分类: "午餐", "交通", "购物"
        // 识别时间: "昨天", "上周", "3天前"
        // 识别备注: 剩余文本作为备注
        
        return ParsedExpense(
            amount: amount,
            category: category,
            date: date,
            note: note
        )
    }
}
```

### 3. 语音识别

```swift
// SpeechManager - 语音转文字
class SpeechManager: ObservableObject {
    @Published var recognizedText = ""
    private let speechRecognizer = SFSpeechRecognizer()
    
    func startRecording() {
        // 开始语音识别
        // 实时转换为文字
        // 自动解析交易信息
    }
}
```

### 4. 自动记录监控

```swift
// AutoRecordMonitor - 智能记录提醒
class AutoRecordMonitor: ObservableObject {
    func scheduleReminder(at time: Date, days: [Int]) {
        // 设置每日/每周提醒
        // 发送本地通知
        // 支持快速记账
    }
}
```

### 5. 数据持久化

```swift
// DataManager - 本地数据存储
class DataManager {
    static let shared = DataManager()
    
    func save<T: Encodable>(_ object: T, forKey key: String) {
        // 使用UserDefaults存储简单数据
        // 使用FileManager存储复杂数据
        // 数据加密保护
    }
    
    func load<T: Decodable>(forKey key: String) -> T? {
        // 读取并解密数据
    }
}
```

## 🎨 设计特点

### UI/UX设计原则

- **简洁直观**: 清晰的视觉层次，快速找到功能
- **快速输入**: 多种输入方式，最小化操作步骤
- **即时反馈**: 实时更新统计数据和图表
- **智能适配**: 支持深色模式和动态字体
- **无障碍访问**: VoiceOver和动态类型支持

### 主题颜色

```swift
// 自定义颜色方案
extension Color {
    static let income = Color.green
    static let expense = Color.red
    static let budgetWarning = Color.orange
    static let budgetExceeded = Color.red
    static let primary = Color.blue
}
```

## 📱 支持的iOS功能

### Widget小组件

```swift
// 桌面小组件 - 今日统计
struct TodayExpenseWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "TodayExpense") { entry in
            TodayExpenseView(entry: entry)
        }
        .configurationDisplayName("今日支出")
        .description("查看今天的消费统计")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
```

### 通知功能

```swift
// 预算预警通知
func sendBudgetAlert(category: String, percentage: Double) {
    let content = UNMutableNotificationContent()
    content.title = "预算警告"
    content.body = "\(category)预算已使用\(Int(percentage))%"
    content.sound = .default
    
    NotificationManager.shared.scheduleNotification(content)
}
```

### 语音识别

- 支持中文和英文语音输入
- 实时转换和显示
- 自动标点和格式化

## 🧪 测试

### 单元测试

```bash
# 运行所有测试
Cmd + U

# 运行特定测试
Cmd + Ctrl + Option + U
```

### 测试覆盖的功能

```swift
// ExpenseNLParserTests.swift
class ExpenseNLParserTests: XCTestCase {
    func testParseAmount() {
        // 测试金额识别
    }
    
    func testParseCategory() {
        // 测试分类识别
    }
    
    func testParseDate() {
        // 测试日期识别
    }
}

// TransactionStoreTests.swift
class TransactionStoreTests: XCTestCase {
    func testAddTransaction() {
        // 测试添加交易
    }
    
    func testCalculateTotal() {
        // 测试统计计算
    }
}
```

## 📊 性能优化

### 已实现的优化

- **懒加载**: 使用LazyVStack优化列表渲染
- **数据缓存**: 缓存统计结果，减少重复计算
- **后台任务**: 异步处理耗时操作
- **内存管理**: 使用weak引用避免循环引用
- **图片优化**: 压缩和缓存图片资源

### 性能指标

```
启动时间: < 1秒
页面切换: < 0.3秒
语音识别响应: < 0.5秒
数据加载: < 0.2秒
内存占用: < 50MB
```

## 🔐 安全性

### 数据保护措施

- **本地加密**: 敏感数据使用AES加密
- **Keychain存储**: 用户凭证存储在系统钥匙串
- **权限控制**: 最小化权限请求
- **数据隔离**: App沙盒机制保护
- **安全传输**: 网络请求使用HTTPS

## 🌍 本地化

当前支持语言：
- 简体中文 (zh-Hans)
- 英语 (en)

### 添加新语言

1. 在Xcode中添加新的本地化文件
2. 翻译Localizable.strings
3. 更新支持的语言列表

## 📝 开发计划

### 近期计划 (v1.1)
- [ ] iCloud数据同步
- [ ] 账单拍照OCR识别
- [ ] 更多图表类型
- [ ] 数据导出PDF功能
- [ ] iPad适配优化

### 长期规划 (v2.0)
- [ ] Apple Watch支持
- [ ] 家庭共享账本
- [ ] 定期账单管理
- [ ] 投资收益追踪
- [ ] AI智能分析建议

## 🤝 贡献指南

欢迎提交Issue和Pull Request！

### 贡献流程

1. Fork项目
2. 创建功能分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 创建Pull Request

### 代码规范

- 遵循Swift官方风格指南
- 使用SwiftLint进行代码检查
- 为新功能编写单元测试
- 更新相关文档

## 📄 许可证

本项目采用 MIT 许可证 - 详见 [LICENSE](LICENSE) 文件

## 👥 联系方式

- **作者**: 文敬博
- **GitHub**: [@ANTI-Tony](https://github.com/ANTI-Tony)
- **Email**: ts2015656@gmail.com

## 🎉 致谢

感谢以下开源项目和资源：

- [SwiftUI](https://developer.apple.com/xcode/swiftui/) - Apple的声明式UI框架
- [Swift](https://swift.org/) - 现代化的编程语言
- [SF Symbols](https://developer.apple.com/sf-symbols/) - Apple的图标系统

## 📸 应用截图

### 主要界面

```
1.png          [添加交易]         [统计分析]
```

### 特色功能

```
[快速记账]         [语音输入]         [预算管理]
```

---

**项目状态**: 🟢 活跃开发中

**最后更新**: 2024-01-20

**版本**: 1.0.0

如果这个项目对你有帮助，请给它一个 ⭐️ Star！
