import SwiftUI

struct AuthContentView: View {
    @StateObject var authViewModel: AuthViewModel

    var body: some View {
        if authViewModel.isSignedIn {
            MainTabView() // твой основной TabView
        } else {
            LoginView(authViewModel: authViewModel)
        }
    }
}

