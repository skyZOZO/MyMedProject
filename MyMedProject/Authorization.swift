import SwiftUI

struct UnifiedAuthView: View {
    @State private var isSignIn = true
    @State private var email = ""
    @State private var password = ""
    @State private var showPassword = false
    @State private var localError: String?
    @State private var showForgotPassword = false
    @State private var animateAppear = false
    @State private var navigateToAnketa = false // для перехода после регистрации

    @ObservedObject var authViewModel: AuthViewModel

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [ Color(hex: "DDEEFF"), Color(hex: "F7FBFF")],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                VStack(spacing: 35) {
                    Text("DEM APP")
                        .font(.custom("Gloock", size: 80))
                        .bold()
                        .foregroundColor(Color(hex: "0A2A43"))
                        .padding(.top, 40)
                        .shadow(radius: 5)
                        .opacity(animateAppear ? 1 : 0)
                        .scaleEffect(animateAppear ? 1 : 0.98)
                        .animation(.easeOut(duration: 0.5), value: animateAppear)

                    Text(isSignIn ? "Добро пожаловать 👋" : "Создай свой аккаунт 🚀")
                        .font(.title2)
                        .foregroundColor(.gray)
                        .animation(.easeInOut, value: isSignIn)

                    // Sign In / Sign Up кнопки
                    HStack(spacing: 0) {
                        Button(action: { toggleAuth(true) }) {
                            Text("Sign In")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .font(.headline)
                                .foregroundColor(isSignIn ? .white : .gray)
                                .background(isSignIn ? Color(hex: "144B75") : Color.clear)
                                .cornerRadius(15)
                        }

                        Button(action: { toggleAuth(false) }) {
                            Text("Sign Up")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .font(.headline)
                                .foregroundColor(!isSignIn ? .white : .gray)
                                .background(!isSignIn ? Color(hex: "144B75") : Color.clear)
                                .cornerRadius(15)
                        }
                    }
                    .background(.ultraThinMaterial)
                    .cornerRadius(20)
                    .padding(.horizontal, 40)
                    .shadow(radius: 6)

                    // Поля ввода
                    VStack(spacing: 15) {
                        HStack {
                            Image(systemName: "envelope")
                                .foregroundColor(Color(hex: "0A2A43"))
                            TextField("Email", text: $email)
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                        }
                        .padding()
                        .background(.regularMaterial)
                        .cornerRadius(20)
                        .shadow(color: .black.opacity(0.12), radius: 7, x: 0, y: 4)

                        HStack {
                            Image(systemName: "lock")
                                .foregroundColor(Color(hex: "0A2A43"))
                            if showPassword {
                                TextField("Пароль", text: $password)
                                    .autocapitalization(.none)
                            } else {
                                SecureField("Пароль", text: $password)
                                    .autocapitalization(.none)
                            }
                            Button(action: { showPassword.toggle() }) {
                                Image(systemName: showPassword ? "eye.slash" : "eye")
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding()
                        .background(.regularMaterial)
                        .cornerRadius(20)
                        .shadow(color: .black.opacity(0.12), radius: 7, x: 0, y: 4)

                        if let error = localError {
                            Text(error)
                                .foregroundColor(.red)
                                .font(.caption)
                        } else if let vmError = authViewModel.errorMessage {
                            Text(vmError)
                                .foregroundColor(.red)
                                .font(.caption)
                        }
                    }
                    .padding(.horizontal, 40)

                    // Забыли пароль
                    if isSignIn {
                        Button(action: { showForgotPassword = true }) {
                            Text("Забыли пароль?")
                                .font(.subheadline)
                                .foregroundColor(Color(hex: "0A2A43"))
                        }
                        .padding(.horizontal, 40)
                        .sheet(isPresented: $showForgotPassword) {
                            ForgotPasswordView(authViewModel: authViewModel)
                        }
                    }

                    Button(action: handleAuthButton) {
                        Text(isSignIn ? "Войти" : "Создать аккаунт")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                LinearGradient(
                                    colors: [Color(hex: "144B75"), Color(hex: "0A2A43")],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(20)
                            .shadow(radius: 8)
                    }
                    .padding(.horizontal, 40)
                    .padding(.top, 10)
                    .disabled(email.isEmpty || password.isEmpty)

                    Spacer(minLength: 40)
                }
                .onAppear { animateAppear = true }

                // ------------------ Навигация на Анкету ------------------
                NavigationLink(
                            destination: AnketaView(authViewModel: authViewModel)
                                .navigationBarBackButtonHidden(true),
                            isActive: $authViewModel.shouldShowAnketa,
                            label: { EmptyView() }
                        )
            }
        }
    }

    // ------------------ Функции ------------------
    private func toggleAuth(_ signIn: Bool) {
        withAnimation(.spring()) {
            isSignIn = signIn
            clearFieldsOnToggle()
        }
    }

    private func handleAuthButton() {
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

        if isSignIn {
            authViewModel.signIn(email: trimmedEmail, password: trimmedPassword)
        } else {
            authViewModel.signUp(email: trimmedEmail, password: trimmedPassword) { success in
                if success {
                    // Переходим на Анкету
                    withAnimation {
                        navigateToAnketa = true
                    }
                }
            }
        }
    }

    private func clearFieldsOnToggle() {
        email = ""
        password = ""
        showPassword = false
        localError = nil
    }

    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
}

