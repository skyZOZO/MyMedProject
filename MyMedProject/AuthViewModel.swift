import SwiftUI
import FirebaseAuth
import FirebaseFirestore

// MARK: - Модель пользователя
struct User {
    var username: String
    var email: String
}

class AuthViewModel: ObservableObject {
    @Published var isSignedIn = false
    @Published var currentUser: User = User(username: "", email: "")
    @Published var errorMessage: String?
    @Published var shouldShowAnketa = false

    private var db = Firestore.firestore()

    init() {
        self.isSignedIn = Auth.auth().currentUser != nil
        fetchUserData()
    }

    // Регистрация
    func signUp(email: String, password: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                    completion(false)
                } else {
                    // Показываем анкету
                    self?.shouldShowAnketa = true
                    completion(true)
                }
            }
        }
    }

    // Авторизация
    func signIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                } else {
                    self?.isSignedIn = true
                    self?.fetchUserData()
                }
            }
        }
    }

    // Выход
    func signOut() {
        try? Auth.auth().signOut()
        self.isSignedIn = false
        self.currentUser = User(username: "", email: "")
    }

    // Получение данных пользователя
    func fetchUserData() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let email = Auth.auth().currentUser?.email ?? ""

        db.collection("users").document(uid).getDocument { [weak self] snapshot, error in
            if let data = snapshot?.data(), error == nil {
                let username = data["username"] as? String ?? ""
                DispatchQueue.main.async {
                    self?.currentUser = User(username: username, email: email)
                }
            } else {
                DispatchQueue.main.async {
                    self?.currentUser = User(username: "", email: email)
                }
            }
        }
    }

    // Сохранение анкеты и обновление профиля
    func completeAnketa(username: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let email = Auth.auth().currentUser?.email ?? ""
        let data: [String: Any] = ["username": username, "email": email]
        db.collection("users").document(uid).setData(data, merge: true)

        db.collection("users").document(uid).setData(data) { [weak self] error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                } else {
                    self?.currentUser = User(username: username, email: email)
                    self?.isSignedIn = true
                    self?.shouldShowAnketa = false
                }
            }
        }
    }

}
