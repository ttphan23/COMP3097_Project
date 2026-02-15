import Foundation
import Combine

struct StoredUser: Codable, Hashable {
    var firstName: String
    var lastName: String
    var dob: Date
    var email: String
    var password: String
}

final class UserStore: ObservableObject {
    @Published var currentUser: StoredUser? = nil
    @Published private(set) var users: [StoredUser] = []

    private let usersKey = "eduVantage_users_v1"
    private let currentKey = "eduVantage_current_user_v1"

    init() {
        loadUsers()
        loadCurrentUser()
    }
    
// MARK: - Sign Up (unique email)

    func signUp(_ newUser: StoredUser) throws {
        let newEmail = normalizeEmail(newUser.email)

        if users.contains(where: { normalizeEmail($0.email) == newEmail }) {
            throw SignUpError.emailAlreadyInUse
        }

        users.append(newUser)
        saveUsers()

        currentUser = newUser
        saveCurrentUser()
    }

    // MARK: - Sign In

    func signIn(email: String, password: String) -> Bool {
        let e = normalizeEmail(email)
        guard let found = users.first(where: { normalizeEmail($0.email) == e && $0.password == password }) else {
            return false
        }

        currentUser = found
        saveCurrentUser()
        return true
    }

    // MARK: - Sign Out

    func signOut() {
        currentUser = nil
        UserDefaults.standard.removeObject(forKey: currentKey)
    }

    // MARK: - Helpers

    private func normalizeEmail(_ email: String) -> String {
        email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    }

    // MARK: - Persistence

    private func saveUsers() {
        do {
            let data = try JSONEncoder().encode(users)
            UserDefaults.standard.set(data, forKey: usersKey)
        } catch {
            print("Save users error:", error)
        }
    }

    private func loadUsers() {
        guard let data = UserDefaults.standard.data(forKey: usersKey) else { return }
        do {
            users = try JSONDecoder().decode([StoredUser].self, from: data)
        } catch {
            users = []
            UserDefaults.standard.removeObject(forKey: usersKey)
            print("Load users error:", error)
        }
    }

    private func saveCurrentUser() {
        do {
            let data = try JSONEncoder().encode(currentUser)
            UserDefaults.standard.set(data, forKey: currentKey)
        } catch {
            print("Save current user error:", error)
        }
    }

    private func loadCurrentUser() {
        guard let data = UserDefaults.standard.data(forKey: currentKey) else { return }
        do {
            currentUser = try JSONDecoder().decode(StoredUser.self, from: data)
        } catch {
            currentUser = nil
            UserDefaults.standard.removeObject(forKey: currentKey)
            print("Load current user error:", error)
        }
    }

    enum SignUpError: Error {
        case emailAlreadyInUse
    }
}
