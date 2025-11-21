import SwiftUI

struct RegisterView: View {
    @State private var email = ""
    @State private var password = ""
    @ObservedObject var authViewModel: AuthViewModel
    @State private var showPassword = false
    @State private var localError: String?
    
    @Environment(\.dismiss) private var dismiss // для закрытия экрана

    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
                Text("Регистрация")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.primaryDark)
            
            VStack(spacing: 16) {
                // Email
                HStack {
                    Image(systemName: "envelope")
                        .foregroundColor(Color(hex: "0A2A43"))
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                }
                .padding()
                .background(Color.surface)
                .cornerRadius(12)
                .shadow(radius: 2)
                
                // Password
                HStack {
                    Image(systemName: "lock")
                        .foregroundColor(Color(hex: "0A2A43"))
                    if showPassword {
                        TextField("Пароль", text: $password)
                            .autocapitalization(.none)
                    } else {
                        SecureField("Пароль", text: $password)
                    }
                    Button(action: { showPassword.toggle() }) {
                        Image(systemName: showPassword ? "eye.slash" : "eye")
                            .foregroundColor(.gray)
                    }
                }
                .padding()
                .background(Color.surface)
                .cornerRadius(12)
                .shadow(radius: 2)
                
                Text("Пароль должен содержать минимум 6 символов")
                    .font(.caption)
                    .foregroundColor(.textSecondary)
            }
            
            // Кнопка Зарегистрироваться
            Button(action: register) {
                Text("Зарегистрироваться")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        Color(hex: "0A2A43")
                    )
                    .cornerRadius(12)
                    .shadow(radius: 3)
            }
            
            Spacer()
            
            // Кнопка перейти на вход
            Button(action: { dismiss() }) {
                HStack {
                    Text("Уже есть аккаунт?")
                        .foregroundColor(.textSecondary)
                    Text("Войти")
                        .foregroundColor(Color(hex: "0A2A43"))
                        .bold()
                }
            }
        }
        .padding()
        .background(Color.background.ignoresSafeArea())
        .navigationBarBackButtonHidden(true) // Скрываем кнопку назад
    }

    func register() {
        localError = nil
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)

        guard isValidEmail(trimmedEmail) else {
            localError = "Некорректный email"
            return
        }

        guard trimmedPassword.count >= 6 else {
            localError = "Пароль должен быть минимум 6 символов"
            return
        }

        authViewModel.signUp(email: trimmedEmail, password: trimmedPassword)
    }

    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
}


