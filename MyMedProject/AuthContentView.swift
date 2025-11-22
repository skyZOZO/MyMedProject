import SwiftUI
import FirebaseAuth

// ----------------- AuthContentView -----------------
struct AuthContentView: View {
    @StateObject var authViewModel = AuthViewModel() // создаём один экземпляр

    var body: some View {
        Group {
            if authViewModel.isSignedIn {
                MainTabView(authVM: authViewModel) // <- передаём сюда
            } else {
                UnifiedAuthView(authViewModel: authViewModel)
            }
        }
        .animation(.easeInOut, value: authViewModel.isSignedIn)
    }
}
