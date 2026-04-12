//
//  StudyFeatureStore.swift
//  EducationApp
//
//  Created by Yeoch on 2026-04-12.
//

import Foundation
import Combine

final class StudyFeatureStore: ObservableObject {
    static let shared = StudyFeatureStore()

    @Published var flashcardDecks: [FlashcardDeck] = []
    @Published var studySessions: [StudySession] = []
    @Published var courseReviews: [CourseTextReview] = []
    @Published var prerequisiteLinks: [CoursePrerequisiteLink] = []
    @Published var dailyActivities: [DailyLearningActivity] = []

    private let decksKey = "study_feature_flashcard_decks_v1"
    private let sessionsKey = "study_feature_sessions_v1"
    private let reviewsKey = "study_feature_reviews_v1"
    private let prerequisitesKey = "study_feature_prerequisites_v1"
    private let activitiesKey = "study_feature_daily_activities_v1"

    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    private let calendar = Calendar.current

    private init() {
        loadAll()
        if prerequisiteLinks.isEmpty {
            seedSamplePrerequisites()
        }
    }

    // MARK: - Load / Save

    private func loadAll() {
        flashcardDecks = load([FlashcardDeck].self, key: decksKey) ?? []
        studySessions = load([StudySession].self, key: sessionsKey) ?? []
        courseReviews = load([CourseTextReview].self, key: reviewsKey) ?? []
        prerequisiteLinks = load([CoursePrerequisiteLink].self, key: prerequisitesKey) ?? []
        dailyActivities = load([DailyLearningActivity].self, key: activitiesKey) ?? []
    }

    private func saveAll() {
        save(flashcardDecks, key: decksKey)
        save(studySessions, key: sessionsKey)
        save(courseReviews, key: reviewsKey)
        save(prerequisiteLinks, key: prerequisitesKey)
        save(dailyActivities, key: activitiesKey)
    }

    private func save<T: Codable>(_ value: T, key: String) {
        do {
            let data = try encoder.encode(value)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            print("Failed to save \(key): \(error)")
        }
    }

    private func load<T: Codable>(_ type: T.Type, key: String) -> T? {
        guard let data = UserDefaults.standard.data(forKey: key) else { return nil }
        do {
            return try decoder.decode(type, from: data)
        } catch {
            print("Failed to load \(key): \(error)")
            return nil
        }
    }

    // MARK: - Flashcards

    func deck(for courseId: String, lessonId: String, title: String) -> FlashcardDeck {
        if let existing = flashcardDecks.first(where: { $0.courseId == courseId && $0.lessonId == lessonId }) {
            return existing
        }

        let newDeck = FlashcardDeck(courseId: courseId, lessonId: lessonId, title: title)
        flashcardDecks.append(newDeck)
        saveAll()
        return newDeck
    }

    func cards(for courseId: String, lessonId: String, title: String) -> [Flashcard] {
        deck(for: courseId, lessonId: lessonId, title: title).cards
    }

    func addFlashcard(courseId: String, lessonId: String, title: String, front: String, back: String) {
        guard !front.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              !back.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }

        let deck = deck(for: courseId, lessonId: lessonId, title: title)
        guard let index = flashcardDecks.firstIndex(where: { $0.id == deck.id }) else { return }

        flashcardDecks[index].cards.append(
            Flashcard(
                front: front.trimmingCharacters(in: .whitespacesAndNewlines),
                back: back.trimmingCharacters(in: .whitespacesAndNewlines)
            )
        )
        saveAll()
    }

    func deleteFlashcard(deckId: String, cardId: String) {
        guard let deckIndex = flashcardDecks.firstIndex(where: { $0.id == deckId }) else { return }
        flashcardDecks[deckIndex].cards.removeAll { $0.id == cardId }
        saveAll()
    }

    func markFlashcardResult(deckId: String, cardId: String, correct: Bool) {
        guard let deckIndex = flashcardDecks.firstIndex(where: { $0.id == deckId }),
              let cardIndex = flashcardDecks[deckIndex].cards.firstIndex(where: { $0.id == cardId }) else { return }

        flashcardDecks[deckIndex].cards[cardIndex].lastReviewed = Date()
        if correct {
            flashcardDecks[deckIndex].cards[cardIndex].correctCount += 1
        } else {
            flashcardDecks[deckIndex].cards[cardIndex].incorrectCount += 1
        }
        saveAll()
    }

    // MARK: - Study Timer / Sessions

    func recordStudySession(courseId: String?, courseTitle: String?, focusMinutes: Int, breakMinutes: Int) {
        let endDate = Date()
        let startDate = endDate.addingTimeInterval(TimeInterval(-focusMinutes * 60))

        let session = StudySession(
            courseId: courseId,
            courseTitle: courseTitle,
            startDate: startDate,
            endDate: endDate,
            focusMinutes: focusMinutes,
            breakMinutes: breakMinutes,
            completed: true
        )

        studySessions.insert(session, at: 0)
        updateActivity(
            for: endDate,
            studyMinutes: focusMinutes,
            coursesProgressed: 0,
            quizzesPassed: 0,
            sessionsCompleted: 1
        )
        saveAll()
    }

    func recordQuizPassed(on date: Date = Date()) {
        updateActivity(
            for: date,
            studyMinutes: 0,
            coursesProgressed: 0,
            quizzesPassed: 1,
            sessionsCompleted: 0
        )
        saveAll()
    }

    func recordCourseProgress(on date: Date = Date()) {
        updateActivity(
            for: date,
            studyMinutes: 0,
            coursesProgressed: 1,
            quizzesPassed: 0,
            sessionsCompleted: 0
        )
        saveAll()
    }

    private func updateActivity(
        for date: Date,
        studyMinutes: Int,
        coursesProgressed: Int,
        quizzesPassed: Int,
        sessionsCompleted: Int
    ) {
        let day = calendar.startOfDay(for: date)

        if let index = dailyActivities.firstIndex(where: { calendar.isDate($0.date, inSameDayAs: day) }) {
            dailyActivities[index].studyMinutes += studyMinutes
            dailyActivities[index].coursesProgressed += coursesProgressed
            dailyActivities[index].quizzesPassed += quizzesPassed
            dailyActivities[index].sessionsCompleted += sessionsCompleted
        } else {
            dailyActivities.append(
                DailyLearningActivity(
                    date: day,
                    studyMinutes: studyMinutes,
                    coursesProgressed: coursesProgressed,
                    quizzesPassed: quizzesPassed,
                    sessionsCompleted: sessionsCompleted
                )
            )
        }

        dailyActivities.sort { $0.date > $1.date }
    }

    // MARK: - Reviews

    func reviews(for courseId: String) -> [CourseTextReview] {
        courseReviews
            .filter { $0.courseId == courseId }
            .sorted { $0.createdAt > $1.createdAt }
    }

    func addReview(courseId: String, courseTitle: String, authorName: String, rating: Int, reviewText: String) {
        let cleanText = reviewText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleanText.isEmpty else { return }

        let review = CourseTextReview(
            courseId: courseId,
            courseTitle: courseTitle,
            authorName: authorName.isEmpty ? "Student" : authorName,
            rating: max(1, min(5, rating)),
            reviewText: cleanText
        )

        courseReviews.insert(review, at: 0)
        saveAll()
    }

    // MARK: - Prerequisites

    func prerequisiteCourses(for courseId: String) -> [Course] {
        let linkedIds = prerequisiteLinks
            .filter { $0.courseId == courseId }
            .map(\.prerequisiteCourseId)

        return CourseStore.sampleCourses.filter { linkedIds.contains($0.id) }
    }

    func setPrerequisites(for courseId: String, prerequisiteIds: [String]) {
        prerequisiteLinks.removeAll { $0.courseId == courseId }
        prerequisiteLinks.append(contentsOf: prerequisiteIds.map {
            CoursePrerequisiteLink(courseId: courseId, prerequisiteCourseId: $0)
        })
        saveAll()
    }

    private func seedSamplePrerequisites() {
        let sampleMap: [String: [String]] = [
            "course_quantum_physics_101": ["course_algorithm_design"],
            "course_business_strategy": ["course_modern_art_history"]
        ]

        for (courseId, prereqIds) in sampleMap {
            prerequisiteLinks.append(contentsOf: prereqIds.map {
                CoursePrerequisiteLink(courseId: courseId, prerequisiteCourseId: $0)
            })
        }

        saveAll()
    }

    // MARK: - Reports / Heat Map

    func summary(forLastDays days: Int) -> StudySummary {
        let startDate = calendar.date(
            byAdding: .day,
            value: -(days - 1),
            to: calendar.startOfDay(for: Date())
        ) ?? Date()

        let items = dailyActivities.filter { $0.date >= startDate }

        return StudySummary(
            totalStudyMinutes: items.reduce(0) { $0 + $1.studyMinutes },
            coursesProgressed: items.reduce(0) { $0 + $1.coursesProgressed },
            quizzesPassed: items.reduce(0) { $0 + $1.quizzesPassed },
            sessionsCompleted: items.reduce(0) { $0 + $1.sessionsCompleted }
        )
    }

    func heatMapDates(weeks: Int = 12) -> [Date] {
        let totalDays = weeks * 7
        let today = calendar.startOfDay(for: Date())

        return (0..<totalDays).compactMap { offset in
            calendar.date(byAdding: .day, value: -(totalDays - 1 - offset), to: today)
        }
    }

    func activityLevel(for date: Date) -> Int {
        guard let item = dailyActivities.first(where: { calendar.isDate($0.date, inSameDayAs: date) }) else {
            return 0
        }

        switch item.activityScore {
        case 0:
            return 0
        case 1...29:
            return 1
        case 30...59:
            return 2
        case 60...119:
            return 3
        default:
            return 4
        }
    }
}
