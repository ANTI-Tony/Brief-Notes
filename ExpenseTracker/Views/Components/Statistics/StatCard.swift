import SwiftUI
import Charts

struct StatCard: View {
    let title: String
    let value: Double
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Text("¥\(value, specifier: "%.2f")")
                .font(.headline)
                .foregroundColor(color)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.secondary.opacity(0.1))
        .cornerRadius(10)
    }
}
