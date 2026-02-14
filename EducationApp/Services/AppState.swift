import SwiftUI
import Combine

final class AppState: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var path = NavigationPath()
}

enum Route: Hashable {
    case createAccount
    case signIn
    case verifyEmail(String)
}
