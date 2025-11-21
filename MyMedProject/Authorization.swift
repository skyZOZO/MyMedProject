import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @ObservedObject var authViewModel: AuthViewModel
    @State private var localError: String?
    @State private var showPassword = false
    @State private var showRegister = false
    @State private var showForgotPassword = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                Spacer()
                Text("Вход")
                    .font(.largeTitle).bold()
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
                    
                    // Ошибки
                    if let error = localError {
                        Text(error).foregroundColor(.red).font(.caption)
                    }
                    if let error = authViewModel.errorMessage {
                        Text(error).foregroundColor(.red).font(.caption)
                    }
                }
                
                // Кнопка Войти
                Button(action: login) {
                    Text("Войти")
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
                
                // Забыли пароль
                Button(action: { showForgotPassword = true }) {
                    Text("Забыли пароль?")
                        .font(.subheadline)
                        .foregroundColor(Color(hex: "0A2A43"))
                }
                .sheet(isPresented: $showForgotPassword) {
                    ForgotPasswordView(authViewModel: authViewModel)
                }
                
                Spacer()
                
                // Переход на регистрацию
                HStack {
                    Text("Нет аккаунта?")
                        .foregroundColor(.textSecondary)
                    NavigationLink("Зарегистрироваться") {
                        RegisterView(authViewModel: authViewModel)
                    }
                    .foregroundColor(Color(hex: "0A2A43"))
                }
            }
            .padding()
            .background(Color.background.ignoresSafeArea())
        }
    }

    func login() {
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

        authViewModel.signIn(email: trimmedEmail, password: trimmedPassword)
    }

    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
}
