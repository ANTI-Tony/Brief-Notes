import SwiftUI
import Charts

struct StatBox: View {
    let title: String
    let value: Double
    let textColor: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
            Text("¥\(value, specifier: "%.2f")")
                .font(.headline)
                .foregroundColor(textColor)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}
