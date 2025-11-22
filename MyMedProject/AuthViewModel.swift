import FirebaseAuth
import Foundation

class AuthViewModel: ObservableObject {
    @Published var isSignedIn = false
    @Published var errorMessage: String?

    var user: User? {
        Auth.auth().currentUser
    }

    func signUp(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                    print("SignUp Error: \(error.localizedDescription)")
                } else {
                    self?.isSignedIn = true
                    print("SignUp Success")
                }
            }
        }
    }

    func signIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                    print("SignIn Error: \(error.localizedDescription)")
                } else {
                    self?.isSignedIn = true
                    print("SignIn Success")
                }
            }
        }
    }

    func signOut() {
        try? Auth.auth().signOut()
        self.isSignedIn = false
    }
}

