import SwiftUI
struct CategoriesView: View {
    var body: some View {
        VStack {
            Text("Категории (в разработке)")
                .font(.title2)
                .foregroundColor(.textSecondary)
            Spacer()
        }
        .padding()
        .navigationTitle("Категории")
    }
}
