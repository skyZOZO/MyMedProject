import SwiftUI

struct RootView: View {
    @StateObject var authVM = AuthViewModel() // одна VM для всего

    var body: some View {
        if authVM.isSignedIn {
            MainTabView(authVM: authVM) // показываем профиль + остальные табы
        } else {
            UnifiedAuthView(authViewModel: authVM) // экран авторизации
        }
    }
}

struct ProfileView: View {
    @ObservedObject var viewModel: AuthViewModel
    @State private var isDarkMode = false

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Верхний блок: аватар и email/имя
                VStack(spacing: 8) {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.darkBlue)

                    if viewModel.currentUser.username.isEmpty {
                        Text(viewModel.currentUser.email)
                            .font(.title2)
                            .bold()
                    } else {
                        Text(viewModel.currentUser.username)
                            .font(.title2)
                            .bold()
                        Text(viewModel.currentUser.email)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.top, 30)

                // Секции настроек и поддержки (как было)
                VStack(spacing: 1) {
                    ProfileRow(icon: "gearshape", title: "Настройки профиля")
                    ProfileRow(icon: "bell", title: "Уведомления")
                    ProfileRow(icon: "lock.shield", title: "Безопасность")
                    ProfileRow(icon: "star.circle", title: "Подписки / Премиум")
                    ProfileRow(icon: "person.3.fill", title: "О команде")
                    ProfileRowWithToggle(icon: "moon.fill", title: "Темная тема", isOn: $isDarkMode)
                }
                .background(.ultraThinMaterial)
                .cornerRadius(12)
                .padding(.horizontal)

                VStack(spacing: 1) {
                    ProfileRow(icon: "questionmark.circle", title: "Помощь и FAQ")
                    ProfileRow(icon: "envelope", title: "Техподдержка")
                }
                .background(.ultraThinMaterial)
                .cornerRadius(12)
                .padding(.horizontal)

                // Кнопка выйти
                Button(action: {
                    viewModel.signOut() // это меняет isSignedIn
                }) {
                    Text("Выйти из аккаунта")
                        .foregroundColor(.red)
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(12)
                }
                .padding(.horizontal)
                .padding(.top, 10)

                Spacer()
            }
            .navigationBarHidden(true)
        }
    }
}

// MARK: - Компоненты строки
struct ProfileRow: View {
    var icon: String
    var title: String

    var body: some View {
        HStack {
            Image(systemName: icon)
                .frame(width: 30)
                .foregroundColor(.darkBlue)
            Text(title)
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.white.opacity(0.001))
    }
}

struct ProfileRowWithToggle: View {
    var icon: String
    var title: String
    @Binding var isOn: Bool

    var body: some View {
        HStack {
            Image(systemName: icon)
                .frame(width: 30)
                .foregroundColor(.darkBlue)
            Text(title)
            Spacer()
            Toggle("", isOn: $isOn)
                .labelsHidden()
        }
        .padding()
        .background(Color.white.opacity(0.001))
    }
}
