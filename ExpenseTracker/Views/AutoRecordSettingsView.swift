import SwiftUI

struct AutoRecordSettingsView: View {
   @State private var isSMSRecordEnabled = false
   
   var body: some View {
       Form {
           Section(header: Text("settings.auto.record.settings".localized())) {
               Toggle("settings.auto.record.sms.enable".localized(), isOn: $isSMSRecordEnabled)
                   .onChange(of: isSMSRecordEnabled) { newValue in
                       if newValue {
                           SMSManager.shared.requestSMSPermission()
                       }
                   }
               
               if isSMSRecordEnabled {
                   Text("settings.auto.record.sms.description".localized())
                       .font(.caption)
                       .foregroundColor(.secondary)
               }
           }
           
           Section(header: Text("settings.auto.record.sms.types".localized())) {
               Label("settings.auto.record.sms.wechat.payment".localized(), systemImage: "message.fill")
               Label("settings.auto.record.sms.wechat.transaction".localized(), systemImage: "message.fill")
           }
           
           Section(header: Text("settings.auto.record.notes".localized())) {
               Text("settings.auto.record.note.format".localized())
               Text("settings.auto.record.note.requirement".localized())
               Text("settings.auto.record.note.category".localized())
           }
           .font(.caption)
       }
       .navigationTitle("settings.auto.record.settings".localized())
   }
}
