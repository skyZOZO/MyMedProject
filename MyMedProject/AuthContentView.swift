import SwiftUI
import FirebaseAuth

// ----------------- AuthContentView -----------------
struct AuthContentView: View {
    @StateObject var authViewModel = AuthViewModel() // создаём один экземпляр

    var body: some View {
        Group {
            if authViewModel.isSignedIn {
                MainTabView() // главная страница после входа
            } else {
                UnifiedAuthView(authViewModel: authViewModel) // используем тот же ViewModel
            }
        }
        .animation(.easeInOut, value: authViewModel.isSignedIn)
    }
}
