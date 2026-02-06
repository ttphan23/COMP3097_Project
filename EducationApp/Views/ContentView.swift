import SwiftUI

struct ContentView: View {
    @State private var isLoggedIn: Bool = false

    var body: some View {
        if isLoggedIn {
            MainAppView(isLoggedIn: $isLoggedIn)
        } else {
            NavigationStack {
                WelcomeScreen(isLoggedIn: $isLoggedIn)
                    .navigationBarHidden(true)
            }
        }
    }
}

#Preview {
    ContentView()
}
