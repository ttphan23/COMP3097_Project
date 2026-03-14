import SwiftUI

struct ContentView: View {
    @State private var isLoggedIn: Bool = false
    @StateObject private var persistenceManager = DataPersistenceManager.shared

    var body: some View {
        Group {
            if isLoggedIn {
                MainAppView(isLoggedIn: $isLoggedIn)
            } else {
                NavigationStack {
                    WelcomeScreen(isLoggedIn: $isLoggedIn)
                        .navigationBarHidden(true)
                }
            }
        }
        .onAppear {
            if persistenceManager.currentUser != nil {
                isLoggedIn = true
            }
        }
    }
}

#Preview {
    ContentView()
}
