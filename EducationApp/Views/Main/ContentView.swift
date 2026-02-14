import SwiftUI

struct ContentView: View {
    @StateObject private var userStore = UserStore()
    @StateObject private var appState = AppState()

    var body: some View {
        NavigationStack(path: $appState.path) {
            Group {
                if appState.isLoggedIn {
                    MainTabView()
                } else {
                    WelcomeScreen()
                }
            }
            .navigationBarHidden(true)
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .createAccount:
                    CreateAccountView().navigationBarHidden(true)
                case .signIn:
                    SignInView().navigationBarHidden(true)
                case .verifyEmail(let email):
                    VerifyEmailView(email: email).navigationBarHidden(true)
                }
            }
        }
        .environmentObject(userStore)
        .environmentObject(appState)
    }
}

#Preview {
    ContentView()
}
