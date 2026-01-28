import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            WelcomeScreen()
                .navigationBarHidden(true)
        }
    }
}

#Preview {
    ContentView()
}
