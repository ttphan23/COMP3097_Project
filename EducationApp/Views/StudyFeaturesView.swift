//
//  StudyFeaturesView.swift
//  EducationApp
//
//  Created by Yeoch on 2026-04-12.
//

import SwiftUI
import Combine
import AVKit

struct PlaybackSpeedControl: View {
    @Binding var selectedRate: Float

    private let rates: [Float] = [0.5, 1.0, 1.25, 1.5, 2.0]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Playback Speed")
                .font(.headline)

            Picker("Playback Speed", selection: $selectedRate) {
                ForEach(rates, id: \.self) { rate in
                    Text(label(for: rate)).tag(rate)
                }
            }
            .pickerStyle(.segmented)
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    private func label(for rate: Float) -> String {
        switch rate {
        case 0.5: return "0.5x"
        case 1.0: return "1x"
        case 1.25: return "1.25x"
        case 1.5: return "1.5x"
        case 2.0: return "2x"
        default: return "\(rate)x"
        }
    }
}

struct FlashcardsView: View {
    let course: Course
    let lessonId: String
    let lessonTitle: String

    @EnvironmentObject private var store: StudyFeatureStore
    @State private var frontText = ""
    @State private var backText = ""
    @State private var currentIndex = 0
    @State private var showAnswer = false

    private var deck: FlashcardDeck {
        store.deck(for: course.id, lessonId: lessonId, title: "\(course.title) - \(lessonTitle)")
    }

    private var cards: [Flashcard] {
        deck.cards
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Create Flashcard")
                        .font(.title3.bold())

                    TextField("Front (question / term)", text: $frontText)
                        .textFieldStyle(.roundedBorder)

                    TextField("Back (answer / definition)", text: $backText)
                        .textFieldStyle(.roundedBorder)

                    Button("Add Flashcard") {
                        store.addFlashcard(
                            courseId: course.id,
                            lessonId: lessonId,
                            title: "\(course.title) - \(lessonTitle)",
                            front: frontText,
                            back: backText
                        )
                        frontText = ""
                        backText = ""
                        currentIndex = 0
                        showAnswer = false
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 16))

                if cards.isEmpty {
                    ContentUnavailableView(
                        "No Flashcards Yet",
                        systemImage: "rectangle.stack.badge.plus",
                        description: Text("Add cards for this lesson and start reviewing.")
                    )
                } else {
                    VStack(spacing: 16) {
                        Text("Review")
                            .font(.title3.bold())

                        Text("Card \(currentIndex + 1) of \(cards.count)")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)

                        VStack(spacing: 16) {
                            Text(cards[currentIndex].front)
                                .font(.title3.bold())
                                .multilineTextAlignment(.center)

                            if showAnswer {
                                Divider()
                                Text(cards[currentIndex].back)
                                    .font(.body)
                                    .multilineTextAlignment(.center)
                            }
                        }
                        .frame(maxWidth: .infinity, minHeight: 220)
                        .padding()
                        .background(.blue.opacity(0.08))
                        .clipShape(RoundedRectangle(cornerRadius: 18))

                        Button(showAnswer ? "Hide Answer" : "Show Answer") {
                            showAnswer.toggle()
                        }
                        .buttonStyle(.bordered)

                        if showAnswer {
                            HStack {
                                Button("Again") {
                                    store.markFlashcardResult(deckId: deck.id, cardId: cards[currentIndex].id, correct: false)
                                    moveToNextCard()
                                }
                                .buttonStyle(.bordered)

                                Button("Got It") {
                                    store.markFlashcardResult(deckId: deck.id, cardId: cards[currentIndex].id, correct: true)
                                    moveToNextCard()
                                }
                                .buttonStyle(.borderedProminent)
                            }
                        }

                        List {
                            ForEach(cards) { card in
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(card.front)
                                        .font(.headline)
                                    Text(card.back)
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)

                                    Text("Correct: \(card.correctCount) · Again: \(card.incorrectCount)")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                            .onDelete { indexSet in
                                for index in indexSet {
                                    store.deleteFlashcard(deckId: deck.id, cardId: cards[index].id)
                                }
                                currentIndex = 0
                                showAnswer = false
                            }
                        }
                        .frame(minHeight: 250)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Flashcards")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func moveToNextCard() {
        showAnswer = false
        guard !cards.isEmpty else { return }
        currentIndex = (currentIndex + 1) % cards.count
    }
}

struct StudyTimerView: View {
    let course: Course

    @EnvironmentObject private var store: StudyFeatureStore
    @Environment(\.scenePhase) private var scenePhase

    @State private var focusMinutes = 25
    @State private var breakMinutes = 5
    @State private var secondsRemaining = 25 * 60
    @State private var isRunning = false
    @State private var sessionFinished = false

    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack(spacing: 24) {
            Text(course.title)
                .font(.title3.bold())
                .multilineTextAlignment(.center)

            Text(timeString(from: secondsRemaining))
                .font(.system(size: 58, weight: .bold, design: .rounded))
                .monospacedDigit()

            VStack(spacing: 12) {
                Stepper("Focus Minutes: \(focusMinutes)", value: $focusMinutes, in: 5...90, step: 5)
                    .onChange(of: focusMinutes) { _, newValue in
                        if !isRunning {
                            secondsRemaining = newValue * 60
                        }
                    }

                Stepper("Break Minutes: \(breakMinutes)", value: $breakMinutes, in: 1...30, step: 1)
            }
            .padding()
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 16))

            HStack(spacing: 12) {
                Button(isRunning ? "Pause" : "Start") {
                    isRunning.toggle()
                }
                .buttonStyle(.borderedProminent)

                Button("Reset") {
                    isRunning = false
                    secondsRemaining = focusMinutes * 60
                }
                .buttonStyle(.bordered)
            }

            Text("When a focus session finishes, it is logged into weekly/monthly analytics.")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            Spacer()
        }
        .padding()
        .navigationTitle("Study Timer")
        .onReceive(timer) { _ in
            guard isRunning else { return }
            if secondsRemaining > 0 {
                secondsRemaining -= 1
            } else {
                isRunning = false
                sessionFinished = true
                store.recordStudySession(
                    courseId: course.id,
                    courseTitle: course.title,
                    focusMinutes: focusMinutes,
                    breakMinutes: breakMinutes
                )
                secondsRemaining = focusMinutes * 60
            }
        }
        .onChange(of: scenePhase) { _, phase in
            if phase != .active {
                isRunning = false
            }
        }
        .alert("Pomodoro Completed", isPresented: $sessionFinished) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Your study session has been saved to analytics.")
        }
    }

    private func timeString(from totalSeconds: Int) -> String {
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

struct CourseReviewsView: View {
    let course: Course

    @EnvironmentObject private var store: StudyFeatureStore
    @State private var authorName = ""
    @State private var rating = 5
    @State private var reviewText = ""

    private var reviews: [CourseTextReview] {
        store.reviews(for: course.id)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Write a Review")
                        .font(.title3.bold())

                    TextField("Your name", text: $authorName)
                        .textFieldStyle(.roundedBorder)

                    Stepper("Rating: \(rating) / 5", value: $rating, in: 1...5)

                    TextEditor(text: $reviewText)
                        .frame(height: 140)
                        .padding(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )

                    Button("Submit Review") {
                        store.addReview(
                            courseId: course.id,
                            courseTitle: course.title,
                            authorName: authorName,
                            rating: rating,
                            reviewText: reviewText
                        )
                        reviewText = ""
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 16))

                if reviews.isEmpty {
                    ContentUnavailableView(
                        "No Reviews Yet",
                        systemImage: "text.bubble",
                        description: Text("Be the first learner to leave a written review.")
                    )
                } else {
                    VStack(alignment: .leading, spacing: 14) {
                        Text("Student Reviews")
                            .font(.title3.bold())

                        ForEach(reviews) { review in
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text(review.authorName)
                                        .font(.headline)
                                    Spacer()
                                    Text(String(repeating: "★", count: review.rating))
                                        .foregroundStyle(.yellow)
                                }

                                Text(review.reviewText)

                                Text(review.createdAt.formatted(date: .abbreviated, time: .omitted))
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Course Reviews")
    }
}

struct PrerequisitesSection: View {
    let course: Course

    @EnvironmentObject private var store: StudyFeatureStore

    private var prerequisites: [Course] {
        store.prerequisiteCourses(for: course.id)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Prerequisites")
                .font(.title3.bold())

            if prerequisites.isEmpty {
                Text("No prerequisite courses listed.")
                    .foregroundStyle(.secondary)
            } else {
                ForEach(prerequisites) { prerequisite in
                    HStack {
                        Image(systemName: "checkmark.seal.fill")
                            .foregroundStyle(.green)
                        VStack(alignment: .leading) {
                            Text(prerequisite.title)
                                .font(.headline)
                            Text("\(prerequisite.category) • \(prerequisite.difficulty)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

struct AnalyticsDashboardView: View {
    @EnvironmentObject private var store: StudyFeatureStore

    private var weekly: StudySummary {
        store.summary(forLastDays: 7)
    }

    private var monthly: StudySummary {
        store.summary(forLastDays: 30)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Learning Analytics")
                .font(.title3.bold())

            ReportSummaryCard(title: "Weekly Report", summary: weekly)
            ReportSummaryCard(title: "Monthly Report", summary: monthly)

            ActivityHeatMapView()
        }
    }
}

struct ReportSummaryCard: View {
    let title: String
    let summary: StudySummary

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.headline)

            HStack {
                MetricPill(title: "Hours Studied", value: summary.totalStudyHoursText)
                MetricPill(title: "Course Progress", value: "\(summary.coursesProgressed)")
            }

            HStack {
                MetricPill(title: "Quizzes Passed", value: "\(summary.quizzesPassed)")
                MetricPill(title: "Sessions", value: "\(summary.sessionsCompleted)")
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

struct MetricPill: View {
    let title: String
    let value: String

    var body: some View {
        VStack(spacing: 6) {
            Text(value)
                .font(.title3.bold())
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(.white.opacity(0.65))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct ActivityHeatMapView: View {
    @EnvironmentObject private var store: StudyFeatureStore

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 4), count: 7)

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Activity Heat Map")
                .font(.headline)

            LazyVGrid(columns: columns, spacing: 4) {
                ForEach(store.heatMapDates(), id: \.self) { date in
                    RoundedRectangle(cornerRadius: 4)
                        .fill(color(for: store.activityLevel(for: date)))
                        .frame(height: 18)
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(Color.black.opacity(0.05), lineWidth: 0.5)
                        )
                }
            }

            Text("Shows learner activity over the last 12 weeks.")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private func color(for level: Int) -> Color {
        switch level {
        case 1: return .green.opacity(0.25)
        case 2: return .green.opacity(0.45)
        case 3: return .green.opacity(0.70)
        case 4: return .green
        default: return Color(.systemGray5)
        }
    }
}
