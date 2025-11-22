import SwiftUI
struct MyBookingsSimpleView: View {
    var body: some View {
        VStack(spacing: 12) {
            Text("Мои записи (в разработке)")
                .font(.title2)
                .foregroundColor(.textSecondary)
            Spacer()
        }
        .padding()
        .navigationTitle("Мои записи")
    }
}
