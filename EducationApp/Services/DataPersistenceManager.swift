import Foundation
import Combine

class DataPersistenceManager: ObservableObject {
    @Published var appData: AppData = AppData()
    @Published var currentUser: UserProfile?

    private let userDefaults = UserDefaults.standard
    private let appDataKey = "appData"
    private let userKey = "currentUser"
    private let preferencesKey = "userPreferences"

    static let shared = DataPersistenceManager()

    init() {
        loadAppData()
        loadCurrentUser()
    }

    // MARK: - User Management

    func saveCurrentUser(_ user: UserProfile) {
        self.currentUser = user
        appData.user = user

        if let encoded = try? JSONEncoder().encode(user) {
            userDefaults.set(encoded, forKey: userKey)
        }
        saveAppData()
    }

    func loadCurrentUser() {
        if let data = userDefaults.data(forKey: userKey),
           let user = try? JSONDecoder().decode(UserProfile.self, from: data) {
            self.currentUser = user
            appData.user = user
        }
    }

    func deleteCurrentUser() {
        currentUser = nil
        appData.user = nil
        userDefaults.removeObject(forKey: userKey)
        userDefaults.removeObject(forKey: appDataKey)
        appData = AppData()
    }

    // MARK: - Preferences Management

    func updatePreferences(_ preferences: UserPreferences) {
        appData.preferences = preferences

        if let encoded = try? JSONEncoder().encode(preferences) {
            userDefaults.set(encoded, forKey: preferencesKey)
        }
        saveAppData()
    }

    func loadPreferences() -> UserPreferences {
        if let data = userDefaults.data(forKey: preferencesKey),
           let preferences = try? JSONDecoder().decode(UserPreferences.self, from: data) {
            return preferences
        }
        return UserPreferences()
    }

    func updateNotificationPreference(_ enabled: Bool) {
        appData.preferences.notificationsEnabled = enabled
        saveAppData()
    }

    func updateDarkModePreference(_ enabled: Bool) {
        appData.preferences.darkModeEnabled = enabled
        saveAppData()
    }

    func updateLanguagePreference(_ language: String) {
        appData.preferences.language = language
        saveAppData()
    }

    // MARK: - Course Progress Management

    func saveCourseProgress(_ progress: CourseProgress) {
        if let index = appData.courseProgress.firstIndex(where: { $0.id == progress.id }) {
            appData.courseProgress[index] = progress
        } else {
            appData.courseProgress.append(progress)
        }
        saveAppData()
    }

    func getCourseProgress(for courseId: String) -> CourseProgress? {
        return appData.courseProgress.first(where: { $0.courseId == courseId })
    }

    func updateCourseProgress(
        courseId: String,
        completionPercentage: Double,
        lessonsCompleted: Int
    ) {
        if let index = appData.courseProgress.firstIndex(where: { $0.courseId == courseId }) {
            appData.courseProgress[index].completionPercentage = completionPercentage
            appData.courseProgress[index].lessonsCompleted = lessonsCompleted
            appData.courseProgress[index].lastAccessedDate = Date()
        }
        saveAppData()
    }

    func toggleCourseFavorite(courseId: String) {
        if let index = appData.courseProgress.firstIndex(where: { $0.courseId == courseId }) {
            appData.courseProgress[index].isFavorite.toggle()
        }
        saveAppData()
    }

    func getAllCourseProgress() -> [CourseProgress] {
        return appData.courseProgress
    }

    func deleteCourseProgress(courseId: String) {
        appData.courseProgress.removeAll { $0.courseId == courseId }
        saveAppData()
    }

    // MARK: - Lesson Progress Management

    func saveLessonProgress(_ progress: LessonProgress) {
        if let index = appData.lessonProgress.firstIndex(where: { $0.id == progress.id }) {
            appData.lessonProgress[index] = progress
        } else {
            appData.lessonProgress.append(progress)
        }
        saveAppData()
    }

    func getLessonProgress(for lessonId: String) -> LessonProgress? {
        return appData.lessonProgress.first(where: { $0.lessonId == lessonId })
    }

    func updateLessonProgress(
        lessonId: String,
        watchedDuration: Double,
        totalDuration: Double,
        isCompleted: Bool = false
    ) {
        var lesson: LessonProgress

        if let existing = appData.lessonProgress.first(where: { $0.lessonId == lessonId }) {
            lesson = existing
        } else {
            lesson = LessonProgress(
                lessonId: lessonId,
                courseId: "",
                lessonName: ""
            )
        }

        lesson.watchedDuration = watchedDuration
        lesson.totalDuration = totalDuration
        lesson.lastWatchedPosition = watchedDuration
        lesson.isCompleted = isCompleted

        if isCompleted {
            lesson.completionDate = Date()
        }

        saveLessonProgress(lesson)
    }

    func markLessonAsComplete(lessonId: String) {
        if let index = appData.lessonProgress.firstIndex(where: { $0.lessonId == lessonId }) {
            appData.lessonProgress[index].isCompleted = true
            appData.lessonProgress[index].completionDate = Date()
            appData.lessonProgress[index].watchedDuration = appData.lessonProgress[index].totalDuration
        }
        saveAppData()
    }

    func saveLessonNotes(lessonId: String, notes: String) {
        if let index = appData.lessonProgress.firstIndex(where: { $0.lessonId == lessonId }) {
            appData.lessonProgress[index].notes = notes
        }
        saveAppData()
    }

    func rateLessonProgress(lessonId: String, rating: Int) {
        if let index = appData.lessonProgress.firstIndex(where: { $0.lessonId == lessonId }) {
            appData.lessonProgress[index].rating = rating
        }
        saveAppData()
    }

    func getCompletedLessonsCount() -> Int {
        return appData.lessonProgress.filter { $0.isCompleted }.count
    }

    // MARK: - App Data Management

    func saveAppData() {
        appData.lastSyncDate = Date()

        if let encoded = try? JSONEncoder().encode(appData) {
            userDefaults.set(encoded, forKey: appDataKey)
        }
    }

    func loadAppData() {
        if let data = userDefaults.data(forKey: appDataKey),
           let decoded = try? JSONDecoder().decode(AppData.self, from: data) {
            self.appData = decoded
            self.currentUser = decoded.user
        } else {
            self.appData = AppData()
        }
    }

    func clearAllData() {
        userDefaults.removeObject(forKey: appDataKey)
        userDefaults.removeObject(forKey: userKey)
        userDefaults.removeObject(forKey: preferencesKey)
        appData = AppData()
        currentUser = nil
    }

    func exportAppData() -> String? {
        if let encoded = try? JSONEncoder().encode(appData),
           let jsonString = String(data: encoded, encoding: .utf8) {
            return jsonString
        }
        return nil
    }

    func getAppStatistics() -> (
        totalCoursesEnrolled: Int,
        totalCoursesCompleted: Int,
        totalLessonsCompleted: Int,
        averageProgress: Double
    ) {
        let totalEnrolled = appData.courseProgress.count
        let totalCompleted = appData.courseProgress.filter { $0.completionPercentage >= 100.0 }.count
        let totalLessons = appData.lessonProgress.filter { $0.isCompleted }.count
        let avgProgress = totalEnrolled > 0 ? appData.courseProgress.map { $0.completionPercentage }.reduce(0, +) / Double(totalEnrolled) : 0

        return (totalEnrolled, totalCompleted, totalLessons, avgProgress)
    }
}
