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

struct Assignment: Codable, Identifiable {
    var id: String = UUID().uuidString
    var title: String
    var courseName: String
    var dueDate: Date
    var isCompleted: Bool = false
    var icon: String = "doc.fill"

    enum CodingKeys: String, CodingKey {
        case id, title, courseName, dueDate, isCompleted, icon
    }
}

struct Course: Identifiable, Codable {
    var id: String
    var title: String
    var category: String
    var duration: String
    var difficulty: String
    var studentCount: String
    var instructor: String
    var instructorDepartment: String
    var rating: Double
    var reviewCount: String
    var totalHours: String
    var objectives: [String]
    var modules: [CourseModule]
}

struct CourseModule: Identifiable, Codable {
    var id: String
    var title: String
    var duration: String
}

struct CourseStore {
    static let sampleCourses: [Course] = [
        Course(
            id: "course_quantum_physics_101",
            title: "Quantum Physics 101",
            category: "Science",
            duration: "12 Weeks",
            difficulty: "Hard",
            studentCount: "12k",
            instructor: "Dr. Sarah Jenkins",
            instructorDepartment: "Dept. of Physics",
            rating: 4.9,
            reviewCount: "2k",
            totalHours: "18h",
            objectives: [
                "Master the foundational principles of quantum mechanics and wave-particle duality.",
                "Develop problem-solving skills for quantum systems and Schrödinger's equation."
            ],
            modules: [
                CourseModule(id: "qp_mod_1", title: "1. Wave-Particle Duality", duration: "15 mins"),
                CourseModule(id: "qp_mod_2", title: "2. Quantum States", duration: "20 mins"),
                CourseModule(id: "qp_mod_3", title: "3. Schrödinger's Equation", duration: "18 mins")
            ]
        ),
        Course(
            id: "course_modern_art_history",
            title: "Modern Art History",
            category: "Arts",
            duration: "6 Weeks",
            difficulty: "Easy",
            studentCount: "5k",
            instructor: "Prof. Emily Carter",
            instructorDepartment: "Dept. of Fine Arts",
            rating: 4.7,
            reviewCount: "1.2k",
            totalHours: "10h",
            objectives: [
                "Understand the major movements and artists that shaped modern art.",
                "Analyze artworks critically within their historical and cultural contexts."
            ],
            modules: [
                CourseModule(id: "art_mod_1", title: "1. Impressionism Origins", duration: "12 mins"),
                CourseModule(id: "art_mod_2", title: "2. Abstract Expressionism", duration: "14 mins"),
                CourseModule(id: "art_mod_3", title: "3. Pop Art & Beyond", duration: "16 mins")
            ]
        ),
        Course(
            id: "course_algorithm_design",
            title: "Algorithm Design",
            category: "Engineering",
            duration: "10 Weeks",
            difficulty: "Medium",
            studentCount: "8k",
            instructor: "Dr. Michael Chen",
            instructorDepartment: "Dept. of Computer Science",
            rating: 4.8,
            reviewCount: "3k",
            totalHours: "15h",
            objectives: [
                "Master fundamental algorithm design paradigms including divide-and-conquer and dynamic programming.",
                "Analyze time and space complexity of algorithms using Big-O notation."
            ],
            modules: [
                CourseModule(id: "alg_mod_1", title: "1. Big-O Notation", duration: "10 mins"),
                CourseModule(id: "alg_mod_2", title: "2. Sorting Algorithms", duration: "22 mins"),
                CourseModule(id: "alg_mod_3", title: "3. Dynamic Programming", duration: "25 mins")
            ]
        ),
        Course(
            id: "course_business_strategy",
            title: "Business Strategy",
            category: "Business",
            duration: "8 Weeks",
            difficulty: "Medium",
            studentCount: "6k",
            instructor: "Prof. Laura Kim",
            instructorDepartment: "Dept. of Business Administration",
            rating: 4.6,
            reviewCount: "900",
            totalHours: "12h",
            objectives: [
                "Understand competitive strategy frameworks including Porter's Five Forces.",
                "Develop strategic thinking skills for real-world business scenarios."
            ],
            modules: [
                CourseModule(id: "biz_mod_1", title: "1. Competitive Analysis", duration: "14 mins"),
                CourseModule(id: "biz_mod_2", title: "2. Market Positioning", duration: "18 mins"),
                CourseModule(id: "biz_mod_3", title: "3. Growth Strategies", duration: "20 mins")
            ]
        ),
        Course(
            id: "course_intro_psychology",
            title: "Introduction to Psychology",
            category: "Science",
            duration: "8 Weeks",
            difficulty: "Easy",
            studentCount: "15k",
            instructor: "Dr. Sarah Jenkins",
            instructorDepartment: "Dept. of Behavioral Sciences",
            rating: 4.9,
            reviewCount: "2k",
            totalHours: "18h",
            objectives: [
                "Master the foundational principles of neuroscience and how they relate to everyday human behavior.",
                "Develop critical thinking skills to evaluate psychological research and data across diverse cultures."
            ],
            modules: [
                CourseModule(id: "psy_mod_1", title: "1. Foundations of Behavior", duration: "12 mins"),
                CourseModule(id: "psy_mod_2", title: "2. Cognitive Processes", duration: "15 mins"),
                CourseModule(id: "psy_mod_3", title: "3. Social Psychology", duration: "15 mins")
            ]
        )
    ]
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
