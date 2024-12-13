import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false
    @State private var opacity = 0.0
    
    var body: some View {
        if isActive {
            ContentView()
        } else {
            VStack {
                if let iconImage = UIImage(named: "AppIcon60x60") {
                    Image(uiImage: iconImage)
                        .resizable()
                        .frame(width: 150, height: 150)
                        .cornerRadius(30)
                }
                
                Text("记账本")
                    .font(.system(size: 36, weight: .bold))
                    .padding(.top, 30)
                
                Text("tyc说想要，wjb就做了")
                    .font(.system(size: 17))
                    .foregroundColor(.black.opacity(0.5))
                    .padding(.top, 20)
            }
            .opacity(opacity)
            .onAppear {
                // 添加淡入动画
                withAnimation(.easeIn(duration: 0.8)) {
                    opacity = 1.0
                }
                
                // 延迟2秒后切换到主界面
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation {
                        self.isActive = true
                    }
                }
            }
        }
    }
}
