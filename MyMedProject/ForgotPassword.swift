import SwiftUI
import FirebaseAuth

struct ForgotPasswordView: View {
    @State private var email = ""
    @State private var message: String?
    @ObservedObject var authViewModel: AuthViewModel
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ZStack {
            // Полный фон нежно-голубой
            LinearGradient(
                colors: [Color(hex: "DDEEFF"), Color(hex: "F7FBFF")],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack {
                Spacer().frame(height: 60) // чуть поднимаем форму

                // MARK: - Заголовок
                VStack(spacing: 10) {
                    Text("DEM APP")
                        .font(.custom("Gloock", size: 72))
                        .bold()
                        .foregroundColor(Color(hex: "0A2A43"))

                    Text("Восстановление пароля")
                        .font(.title2)
                        .bold()
                        .foregroundColor(Color(hex: "0A2A43"))

                    Text("Введите свой email, и мы отправим ссылку для сброса пароля.")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 30)
                }

                Spacer().frame(height: 40)

                // MARK: - Форма
                VStack(spacing: 16) {
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 3)

                    if let msg = message {
                        Text(msg)
                            .font(.caption)
                            .foregroundColor(.red)
                    }

                    Button(action: sendResetEmail) {
                        Text("Отправить")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(LinearGradient(
                                colors: [Color(hex: "144B75"), Color(hex: "0A2A43")],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
)
                            .cornerRadius(16)
                            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
                    }

                    Button(action: { presentationMode.wrappedValue.dismiss() }) {
                        Text("Назад к входу")
                            .foregroundColor(Color(hex: "0A2A43"))
                            .font(.subheadline)
                    }
                    .padding(.top, 8)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(20)
                .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
                .padding(.horizontal, 30)

                Spacer()
            }
        }
        .navigationBarBackButtonHidden(true)
    }

    func sendResetEmail() {
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        guard isValidEmail(trimmedEmail) else {
            message = "Некорректный email"
            return
        }

        Auth.auth().sendPasswordReset(withEmail: trimmedEmail) { error in
            if let error = error {
                message = error.localizedDescription
            } else {
                message = "Ссылка для сброса пароля отправлена на ваш email."
            }
        }
    }

    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
}


