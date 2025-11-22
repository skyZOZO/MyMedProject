
import SwiftUI

struct AuthRouterView: View {
    @ObservedObject var authViewModel: AuthViewModel

    var body: some View {
        NavigationStack {
            if authViewModel.isSignedIn {
                MainTabView()    // 👉 сюда потом поставим анкету / dashboard
            } else {
                UnifiedAuthView(authViewModel: authViewModel)
            }
        }
    }
}
