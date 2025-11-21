import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false
    @StateObject var authViewModel = AuthViewModel() // <--- добавляем сюда

    var body: some View {
        if isActive {
            AuthContentView(authViewModel: authViewModel)
        } else {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color(hex: "0A2A43"), Color(hex: "1D68DA")]),
                    startPoint: .bottom,
                    endPoint: .top
                )
                .edgesIgnoringSafeArea(.all)

                VStack(spacing: 10) {
                    Text("DEM APP")
                        .font(.custom("Spicy Rice", size: 80))
                        .bold()
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)

                    Text("Ваш медицинский спутник")
                        .font(.custom("Roboto", size: 25))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                }
                .padding()
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    withAnimation {
                        self.isActive = true
                    }
                }
            }
        }
    }
}
