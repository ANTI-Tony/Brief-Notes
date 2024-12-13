import Foundation
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()
    
    private init() {}
    
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("通知权限获取成功")
            } else if let error = error {
                print("通知权限获取失败: \(error.localizedDescription)")
            }
        }
    }
    
    func scheduleBudgetWarning(currentSpent: Double, budget: Double) {
        // 清除之前的通知
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        let threshold = budget * 0.8 // 80% 预算作为警告阈值
        if currentSpent >= threshold {
            let content = UNMutableNotificationContent()
            content.title = "预算提醒"
            content.body = "您的本月支出已达到预算的80%，请注意控制支出"
            content.sound = .default
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
            let request = UNNotificationRequest(identifier: "budgetWarning", content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request)
        }
    }
}
