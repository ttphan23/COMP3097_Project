import Foundation

struct UserProfile: Codable {
    var id: String = UUID().uuidString
    var name: String
    var email: String
    var university: String
    var profileImageURL: String?
    var createdDate: Date
    var coursesEnrolled: [String] = []
    var coursesCompleted: Int = 0
    var streakDays: Int = 0
    var lastActiveDate: Date?

    enum CodingKeys: String, CodingKey {
        case id, name, email, university, profileImageURL
        case createdDate, coursesEnrolled, coursesCompleted
        case streakDays, lastActiveDate
    }
}

struct CourseProgress: Codable, Identifiable {
    var id: String = UUID().uuidString
    var courseId: String
    var courseName: String
    var category: String
    var enrollmentDate: Date
    var completionPercentage: Double = 0.0
    var lessonsCompleted: Int = 0
    var totalLessons: Int = 0
    var lastAccessedDate: Date?
    var isFavorite: Bool = false
    var estimatedCompletionDate: Date?

    enum CodingKeys: String, CodingKey {
        case id, courseId, courseName, category
        case enrollmentDate, completionPercentage, lessonsCompleted
        case totalLessons, lastAccessedDate, isFavorite
        case estimatedCompletionDate
    }
}

struct LessonProgress: Codable, Identifiable {
    var id: String = UUID().uuidString
    var lessonId: String
    var courseId: String
    var lessonName: String
    var isCompleted: Bool = false
    var watchedDuration: Double = 0.0
    var totalDuration: Double = 0.0
    var completionDate: Date?
    var lastWatchedPosition: Double = 0.0
    var notes: String = ""
    var rating: Int = 0

    enum CodingKeys: String, CodingKey {
        case id, lessonId, courseId, lessonName
        case isCompleted, watchedDuration, totalDuration
        case completionDate, lastWatchedPosition, notes, rating
    }
}

struct UserPreferences: Codable {
    var notificationsEnabled: Bool = true
    var darkModeEnabled: Bool = false
    var language: String = "English"
    var autoPlayEnabled: Bool = true
    var playbackQuality: String = "High"
    var privacyLevel: String = "Public"
    var emailNotifications: Bool = true
    var pushNotifications: Bool = true
    var theme: String = "Light"

    enum CodingKeys: String, CodingKey {
        case notificationsEnabled, darkModeEnabled, language
        case autoPlayEnabled, playbackQuality, privacyLevel
        case emailNotifications, pushNotifications, theme
    }
}

struct AppData: Codable {
    var user: UserProfile?
    var courseProgress: [CourseProgress] = []
    var lessonProgress: [LessonProgress] = []
    var preferences: UserPreferences = UserPreferences()
    var lastSyncDate: Date?

    enum CodingKeys: String, CodingKey {
        case user, courseProgress, lessonProgress
        case preferences, lastSyncDate
    }
}
