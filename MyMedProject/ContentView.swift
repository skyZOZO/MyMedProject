import SwiftUI

enum AppTab {
    case home, categories, search, bookings, profile
}

struct MainTabView: View {
    @State private var selectedTab: AppTab = .home
    @ObservedObject var authVM: AuthViewModel

    var body: some View {
        ZStack(alignment: .bottom) {
            Group {
                switch selectedTab {
                case .home:
                    HomeView()
                case .categories:
                    Text("Категории (в разработке)")
                case .search:
                    SearchView()
                case .bookings:
                    Text("Мои записи (в разработке)")
                case .profile:
                    // Передаём тот же VM, чтобы ProfileView видел email/username
                    ProfileView(viewModel: authVM)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.background)
            .ignoresSafeArea()

            GlassTabBar(selectedTab: $selectedTab)
                .padding(.bottom, 8)
        }
        .ignoresSafeArea(.keyboard)
    }
}

// ------------------------------------
// Кастомная таб-бар
struct GlassTabBar: View {
    @Binding var selectedTab: AppTab

    var body: some View {
        HStack(spacing: 40) {
            tabButton(tab: .home, icon: "house.fill")
            tabButton(tab: .categories, icon: "square.grid.2x2.fill")
            tabButton(tab: .search, icon: "magnifyingglass")
            tabButton(tab: .bookings, icon: "calendar")
            tabButton(tab: .profile, icon: "person.crop.circle")
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
        .background(
            BlurView(style: .systemUltraThinMaterial)
                .background(Color.white.opacity(0.2))
        )
        .clipShape(RoundedRectangle(cornerRadius: 30))
        .padding(.horizontal, 20)
        .shadow(color: .black.opacity(0.1), radius: 10, y: 4)
    }

    @ViewBuilder
    func tabButton(tab: AppTab, icon: String) -> some View {
        ZStack {
            if selectedTab == tab {
                BlurView(style: .systemUltraThinMaterial)
                    .background(Color(hex: "BEE3F8").opacity(0.5))
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                    .scaleEffect(selectedTab == tab ? 1.1 : 1.0)
                    .animation(.spring(response: 0.3, dampingFraction: 0.7), value: selectedTab)
            }

            Image(systemName: icon)
                .font(.system(size: 22, weight: .semibold))
                .foregroundColor(selectedTab == tab ? Color(hex: "0A2A43") : .textSecondary)
        }
        .frame(maxWidth: .infinity)
        .onTapGesture {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                selectedTab = tab
            }
        }
    }
}

// ------------------------------------
// BlurView для стеклянного эффекта
struct BlurView: UIViewRepresentable {
    let style: UIBlurEffect.Style
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}
