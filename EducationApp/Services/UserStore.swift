import Foundation
import Combine

struct StoredUser: Codable {
    var firstName: String
    var lastName: String
    var dob: Date
    var email: String
    var password: String
}

final class UserStore: ObservableObject {
    @Published var user: StoredUser? = nil
    private let key = "eduVantage_user_v1"

    init() {
        load()
    }

    func save(_ newUser: StoredUser) {
        user = newUser
        do {
            let data = try JSONEncoder().encode(newUser)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            print("Save error:", error)
        }
    }

    func load() {
        guard let data = UserDefaults.standard.data(forKey: key) else { return }
        do {
            user = try JSONDecoder().decode(StoredUser.self, from: data)
        } catch {
            user = nil
            UserDefaults.standard.removeObject(forKey: key)
            print("Load error (cleared old data):", error)
        }
    }

    func clear() {
        user = nil
        UserDefaults.standard.removeObject(forKey: key)
    }

    func signIn(email: String, password: String) -> Bool {
        guard let u = user else { return false }
        return u.email.lowercased() == email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
            && u.password == password
    }
}
