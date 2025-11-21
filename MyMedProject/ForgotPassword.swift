import SwiftUI
import FirebaseAuth

struct ForgotPasswordView: View {
    @State private var email = ""
    @State private var message: String?
    @ObservedObject var authViewModel: AuthViewModel
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack(spacing: 20) {
            Text("Восстановление пароля")
                .font(.title2).bold()
                .foregroundColor(.textMain)

            Text("Введите свой email, и мы отправим ссылку для сброса пароля.")
                .font(.subheadline)
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)

            TextField("Email", text: $email)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .padding()
                .background(Color.surface)
                .cornerRadius(12)

            if let msg = message {
                Text(msg)
                    .font(.caption)
                    .foregroundColor(.red)
            }

            Button("Отправить") {
                sendResetEmail()
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color(hex: "0A2A43"))
            .foregroundColor(.white)
            .cornerRadius(12)

            Button("Назад к входу") {
                presentationMode.wrappedValue.dismiss()
            }
            .padding(.top, 10)
            .foregroundColor(Color(hex: "0A2A43"))

            Spacer()
        }
        .padding()
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


