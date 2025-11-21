import SwiftUI
import SwiftData
import Firebase

@main
struct MyMedProjectApp: App {
    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            SplashScreenView()
        }
    }
}
