import Foundation
import CoreData
import Combine

class DataPersistenceManager: ObservableObject {
    @Published var currentUser: UserProfile?
    @Published var appData: AppData = AppData()

    private let coreData = CoreDataStack.shared
    private var context: NSManagedObjectContext { coreData.viewContext }

    static let shared = DataPersistenceManager()

    init() {
        loadCurrentUser()
        loadAllData()
    }

    // MARK: - User Management

    func saveCurrentUser(_ user: UserProfile) {
        self.currentUser = user
        appData.user = user

        // Delete any existing user profiles first
        let fetchRequest: NSFetchRequest<CDUserProfile> = CDUserProfile.fetchRequest()
        if let existing = try? context.fetch(fetchRequest) {
            existing.forEach { context.delete($0) }
        }

        let cdUser = CDUserProfile(context: context)
        cdUser.id = user.id
        cdUser.name = user.name
        cdUser.email = user.email
        cdUser.university = user.university
        cdUser.profileImageURL = user.profileImageURL
        cdUser.createdDate = user.createdDate
        cdUser.coursesCompleted = Int32(user.coursesCompleted)
        cdUser.streakDays = Int32(user.streakDays)
        cdUser.lastActiveDate = user.lastActiveDate

        coreData.save()
    }

    func loadCurrentUser() {
        let fetchRequest: NSFetchRequest<CDUserProfile> = CDUserProfile.fetchRequest()
        if let cdUser = try? context.fetch(fetchRequest).first {
            let user = UserProfile(
                id: cdUser.id ?? UUID().uuidString,
                name: cdUser.name ?? "",
                email: cdUser.email ?? "",
                university: cdUser.university ?? "",
                profileImageURL: cdUser.profileImageURL,
                createdDate: cdUser.createdDate ?? Date(),
                coursesCompleted: Int(cdUser.coursesCompleted),
                streakDays: Int(cdUser.streakDays),
                lastActiveDate: cdUser.lastActiveDate
            )
            self.currentUser = user
            appData.user = user
        }
    }

    func updateUserProfile(name: String, email: String, university: String) {
        if var user = currentUser {
            user.name = name
            user.email = email
            user.university = university
            saveCurrentUser(user)
        }
    }

    func deleteCurrentUser() {
        currentUser = nil
        appData = AppData()

        // Clear all Core Data entities
        clearAllData()
    }

    // MARK: - Preferences Management

    func updatePreferences(_ preferences: UserPreferences) {
        appData.preferences = preferences
        savePreferencesToCoreData(preferences)
    }

    func loadPreferences() -> UserPreferences {
        let fetchRequest: NSFetchRequest<CDUserPreferences> = CDUserPreferences.fetchRequest()
        if let cdPrefs = try? context.fetch(fetchRequest).first {
            return UserPreferences(
                notificationsEnabled: cdPrefs.notificationsEnabled,
                darkModeEnabled: cdPrefs.darkModeEnabled,
                language: cdPrefs.language ?? "English",
                autoPlayEnabled: cdPrefs.autoPlayEnabled,
                playbackQuality: cdPrefs.playbackQuality ?? "High",
                privacyLevel: cdPrefs.privacyLevel ?? "Public",
                emailNotifications: cdPrefs.emailNotifications,
                pushNotifications: cdPrefs.pushNotifications,
                theme: cdPrefs.theme ?? "Light"
            )
        }
        return UserPreferences()
    }

    func updateNotificationPreference(_ enabled: Bool) {
        appData.preferences.notificationsEnabled = enabled
        savePreferencesToCoreData(appData.preferences)
    }

    func updateDarkModePreference(_ enabled: Bool) {
        appData.preferences.darkModeEnabled = enabled
        savePreferencesToCoreData(appData.preferences)
    }

    func updateLanguagePreference(_ language: String) {
        appData.preferences.language = language
        savePreferencesToCoreData(appData.preferences)
    }

    private func savePreferencesToCoreData(_ prefs: UserPreferences) {
        let fetchRequest: NSFetchRequest<CDUserPreferences> = CDUserPreferences.fetchRequest()
        let cdPrefs: CDUserPreferences

        if let existing = try? context.fetch(fetchRequest).first {
            cdPrefs = existing
        } else {
            cdPrefs = CDUserPreferences(context: context)
        }

        cdPrefs.notificationsEnabled = prefs.notificationsEnabled
        cdPrefs.darkModeEnabled = prefs.darkModeEnabled
        cdPrefs.language = prefs.language
        cdPrefs.autoPlayEnabled = prefs.autoPlayEnabled
        cdPrefs.playbackQuality = prefs.playbackQuality
        cdPrefs.privacyLevel = prefs.privacyLevel
        cdPrefs.emailNotifications = prefs.emailNotifications
        cdPrefs.pushNotifications = prefs.pushNotifications
        cdPrefs.theme = prefs.theme

        coreData.save()
    }

    // MARK: - Course Progress Management

    func saveCourseProgress(_ progress: CourseProgress) {
        let fetchRequest: NSFetchRequest<CDCourseProgress> = CDCourseProgress.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "courseId == %@", progress.courseId)

        let cdProgress: CDCourseProgress

        if let existing = try? context.fetch(fetchRequest).first {
            cdProgress = existing
        } else {
            cdProgress = CDCourseProgress(context: context)
            cdProgress.id = progress.id
        }

        cdProgress.courseId = progress.courseId
        cdProgress.courseName = progress.courseName
        cdProgress.category = progress.category
        cdProgress.enrollmentDate = progress.enrollmentDate
        cdProgress.completionPercentage = progress.completionPercentage
        cdProgress.lessonsCompleted = Int32(progress.lessonsCompleted)
        cdProgress.totalLessons = Int32(progress.totalLessons)
        cdProgress.lastAccessedDate = progress.lastAccessedDate
        cdProgress.isFavorite = progress.isFavorite
        cdProgress.estimatedCompletionDate = progress.estimatedCompletionDate

        coreData.save()
        loadAllCourseProgress()
    }

    func getCourseProgress(for courseId: String) -> CourseProgress? {
        let fetchRequest: NSFetchRequest<CDCourseProgress> = CDCourseProgress.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "courseId == %@", courseId)

        guard let cdProgress = try? context.fetch(fetchRequest).first else { return nil }
        return mapCourseProgress(cdProgress)
    }

    func updateCourseProgress(courseId: String, completionPercentage: Double, lessonsCompleted: Int) {
        let fetchRequest: NSFetchRequest<CDCourseProgress> = CDCourseProgress.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "courseId == %@", courseId)

        if let cdProgress = try? context.fetch(fetchRequest).first {
            cdProgress.completionPercentage = completionPercentage
            cdProgress.lessonsCompleted = Int32(lessonsCompleted)
            cdProgress.lastAccessedDate = Date()
            coreData.save()
            loadAllCourseProgress()
        }
    }

    func toggleCourseFavorite(courseId: String) {
        let fetchRequest: NSFetchRequest<CDCourseProgress> = CDCourseProgress.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "courseId == %@", courseId)

        if let cdProgress = try? context.fetch(fetchRequest).first {
            cdProgress.isFavorite.toggle()
            coreData.save()
            loadAllCourseProgress()
        }
    }

    func getAllCourseProgress() -> [CourseProgress] {
        return appData.courseProgress
    }

    func getFavoriteCourses() -> [CourseProgress] {
        return appData.courseProgress.filter { $0.isFavorite }
    }

    func isCourseFavorite(courseId: String) -> Bool {
        return appData.courseProgress.first(where: { $0.courseId == courseId })?.isFavorite ?? false
    }

    func getCompletedModuleIds(for courseId: String) -> [String] {
        return appData.lessonProgress
            .filter { $0.courseId == courseId && $0.isCompleted }
            .map { $0.lessonId }
    }

    func deleteCourseProgress(courseId: String) {
        let fetchRequest: NSFetchRequest<CDCourseProgress> = CDCourseProgress.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "courseId == %@", courseId)

        if let results = try? context.fetch(fetchRequest) {
            results.forEach { context.delete($0) }
            coreData.save()
            loadAllCourseProgress()
        }
    }

    // MARK: - Lesson Progress Management

    func saveLessonProgress(_ progress: LessonProgress) {
        let fetchRequest: NSFetchRequest<CDLessonProgress> = CDLessonProgress.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "lessonId == %@", progress.lessonId)

        let cdProgress: CDLessonProgress

        if let existing = try? context.fetch(fetchRequest).first {
            cdProgress = existing
        } else {
            cdProgress = CDLessonProgress(context: context)
            cdProgress.id = progress.id
        }

        cdProgress.lessonId = progress.lessonId
        cdProgress.courseId = progress.courseId
        cdProgress.lessonName = progress.lessonName
        cdProgress.isCompleted = progress.isCompleted
        cdProgress.watchedDuration = progress.watchedDuration
        cdProgress.totalDuration = progress.totalDuration
        cdProgress.completionDate = progress.completionDate
        cdProgress.lastWatchedPosition = progress.lastWatchedPosition
        cdProgress.notes = progress.notes
        cdProgress.rating = Int32(progress.rating)

        coreData.save()
        loadAllLessonProgress()
    }

    func getLessonProgress(for lessonId: String) -> LessonProgress? {
        let fetchRequest: NSFetchRequest<CDLessonProgress> = CDLessonProgress.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "lessonId == %@", lessonId)

        guard let cdProgress = try? context.fetch(fetchRequest).first else { return nil }
        return mapLessonProgress(cdProgress)
    }

    func updateLessonProgress(lessonId: String, watchedDuration: Double, totalDuration: Double, isCompleted: Bool = false) {
        let fetchRequest: NSFetchRequest<CDLessonProgress> = CDLessonProgress.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "lessonId == %@", lessonId)

        if let cdProgress = try? context.fetch(fetchRequest).first {
            cdProgress.watchedDuration = watchedDuration
            cdProgress.totalDuration = totalDuration
            cdProgress.lastWatchedPosition = watchedDuration
            cdProgress.isCompleted = isCompleted
            if isCompleted {
                cdProgress.completionDate = Date()
            }
            coreData.save()
            loadAllLessonProgress()
        }
    }

    func markLessonAsComplete(lessonId: String) {
        let fetchRequest: NSFetchRequest<CDLessonProgress> = CDLessonProgress.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "lessonId == %@", lessonId)

        if let cdProgress = try? context.fetch(fetchRequest).first {
            cdProgress.isCompleted = true
            cdProgress.completionDate = Date()
            cdProgress.watchedDuration = cdProgress.totalDuration
            coreData.save()
            loadAllLessonProgress()
        }
    }

    func saveLessonNotes(lessonId: String, notes: String) {
        let fetchRequest: NSFetchRequest<CDLessonProgress> = CDLessonProgress.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "lessonId == %@", lessonId)

        if let cdProgress = try? context.fetch(fetchRequest).first {
            cdProgress.notes = notes
            coreData.save()
        }
    }

    func rateLessonProgress(lessonId: String, rating: Int) {
        let fetchRequest: NSFetchRequest<CDLessonProgress> = CDLessonProgress.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "lessonId == %@", lessonId)

        if let cdProgress = try? context.fetch(fetchRequest).first {
            cdProgress.rating = Int32(rating)
            coreData.save()
        }
    }

    func getCompletedLessonsCount() -> Int {
        let fetchRequest: NSFetchRequest<CDLessonProgress> = CDLessonProgress.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isCompleted == YES")
        return (try? context.count(for: fetchRequest)) ?? 0
    }

    // MARK: - Assignment Management

    @Published var assignments: [Assignment] = []

    func saveAssignment(_ assignment: Assignment) {
        let fetchRequest: NSFetchRequest<CDAssignment> = CDAssignment.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", assignment.id)

        let cdAssignment: CDAssignment
        if let existing = try? context.fetch(fetchRequest).first {
            cdAssignment = existing
        } else {
            cdAssignment = CDAssignment(context: context)
        }

        cdAssignment.id = assignment.id
        cdAssignment.title = assignment.title
        cdAssignment.courseName = assignment.courseName
        cdAssignment.dueDate = assignment.dueDate
        cdAssignment.isCompleted = assignment.isCompleted
        cdAssignment.icon = assignment.icon

        coreData.save()
        loadAllAssignments()
    }

    func toggleAssignmentCompleted(id: String) {
        let fetchRequest: NSFetchRequest<CDAssignment> = CDAssignment.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)

        if let cdAssignment = try? context.fetch(fetchRequest).first {
            cdAssignment.isCompleted.toggle()
            coreData.save()
            loadAllAssignments()
        }
    }

    func deleteAssignment(id: String) {
        let fetchRequest: NSFetchRequest<CDAssignment> = CDAssignment.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)

        if let results = try? context.fetch(fetchRequest) {
            results.forEach { context.delete($0) }
            coreData.save()
            loadAllAssignments()
        }
    }

    func getAllAssignments() -> [Assignment] {
        return assignments
    }

    func getPendingAssignments() -> [Assignment] {
        return assignments.filter { !$0.isCompleted }.sorted { $0.dueDate < $1.dueDate }
    }

    private func loadAllAssignments() {
        let fetchRequest: NSFetchRequest<CDAssignment> = CDAssignment.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "dueDate", ascending: true)]

        if let results = try? context.fetch(fetchRequest) {
            assignments = results.map { mapAssignment($0) }
        }
    }

    func seedDefaultAssignments() {
        let fetchRequest: NSFetchRequest<CDAssignment> = CDAssignment.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isCompleted == NO")
        let pendingCount = (try? context.count(for: fetchRequest)) ?? 0
        guard pendingCount == 0 else { return }

        // Clear old completed assignments before re-seeding
        let allRequest: NSFetchRequest<CDAssignment> = CDAssignment.fetchRequest()
        if let old = try? context.fetch(allRequest) {
            old.forEach { context.delete($0) }
        }

        let calendar = Calendar.current
        let today = Date()

        let defaults: [(String, String, String, Int)] = [
            ("History Essay", "Modern World History", "book.fill", 0),
            ("Calculus Quiz", "Differentiation Rules", "function", 1),
            ("Physics Lab Report", "Electromagnetism", "flask.fill", 3),
            ("Algorithm Problem Set", "Algorithm Design", "laptopcomputer", 5),
            ("Psychology Research Paper", "Introduction to Psychology", "pencil", 7),
            ("Art Movement Presentation", "Modern Art History", "book.fill", 10),
            ("Business Case Study", "Business Strategy", "doc.fill", 12),
            ("Quantum Mechanics Quiz", "Quantum Physics 101", "function", 14),
        ]

        for (title, course, icon, daysFromNow) in defaults {
            let assignment = Assignment(
                title: title,
                courseName: course,
                dueDate: calendar.date(byAdding: .day, value: daysFromNow, to: today) ?? today,
                icon: icon
            )
            saveAssignment(assignment)
        }
    }

    private func mapAssignment(_ cd: CDAssignment) -> Assignment {
        Assignment(
            id: cd.id ?? UUID().uuidString,
            title: cd.title ?? "",
            courseName: cd.courseName ?? "",
            dueDate: cd.dueDate ?? Date(),
            isCompleted: cd.isCompleted,
            icon: cd.icon ?? "doc.fill"
        )
    }

    // MARK: - App Data Management

    func saveAppData() {
        coreData.save()
    }

    func loadAllData() {
        loadAllCourseProgress()
        loadAllLessonProgress()
        loadAllAssignments()
        appData.preferences = loadPreferences()
    }

    private func loadAllCourseProgress() {
        let fetchRequest: NSFetchRequest<CDCourseProgress> = CDCourseProgress.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "enrollmentDate", ascending: false)]

        if let results = try? context.fetch(fetchRequest) {
            appData.courseProgress = results.map { mapCourseProgress($0) }
        }
    }

    private func loadAllLessonProgress() {
        let fetchRequest: NSFetchRequest<CDLessonProgress> = CDLessonProgress.fetchRequest()

        if let results = try? context.fetch(fetchRequest) {
            appData.lessonProgress = results.map { mapLessonProgress($0) }
        }
    }

    func clearAllData() {
        let entities = ["CDUserProfile", "CDCourseProgress", "CDLessonProgress", "CDUserPreferences", "CDAssignment"]
        for entityName in entities {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
            if let results = try? context.fetch(fetchRequest) {
                results.forEach { context.delete($0) }
            }
        }
        coreData.save()

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

    // MARK: - Mapping Helpers

    private func mapCourseProgress(_ cd: CDCourseProgress) -> CourseProgress {
        CourseProgress(
            id: cd.id ?? UUID().uuidString,
            courseId: cd.courseId ?? "",
            courseName: cd.courseName ?? "",
            category: cd.category ?? "",
            enrollmentDate: cd.enrollmentDate ?? Date(),
            completionPercentage: cd.completionPercentage,
            lessonsCompleted: Int(cd.lessonsCompleted),
            totalLessons: Int(cd.totalLessons),
            lastAccessedDate: cd.lastAccessedDate,
            isFavorite: cd.isFavorite,
            estimatedCompletionDate: cd.estimatedCompletionDate
        )
    }

    private func mapLessonProgress(_ cd: CDLessonProgress) -> LessonProgress {
        LessonProgress(
            id: cd.id ?? UUID().uuidString,
            lessonId: cd.lessonId ?? "",
            courseId: cd.courseId ?? "",
            lessonName: cd.lessonName ?? "",
            isCompleted: cd.isCompleted,
            watchedDuration: cd.watchedDuration,
            totalDuration: cd.totalDuration,
            completionDate: cd.completionDate,
            lastWatchedPosition: cd.lastWatchedPosition,
            notes: cd.notes ?? "",
            rating: Int(cd.rating)
        )
    }
}
