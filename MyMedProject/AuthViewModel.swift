import FirebaseAuth
import Foundation

class AuthViewModel: ObservableObject {
    @Published var isSignedIn = false
    @Published var errorMessage: String?

    var user: User? { Auth.auth().currentUser }

    func signUp(email: String, password: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                    completion(false)
                } else {
                    // Не ставим isSignedIn = true сразу
                    completion(true)
                }
            }
        }
    }

    func signIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                } else {
                    self?.isSignedIn = true // После обычного входа меняем сразу
                }
            }
        }
    }
}
