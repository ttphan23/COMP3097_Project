import SwiftUI
import Combine

struct LessonView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var persistenceManager = DataPersistenceManager.shared
    @EnvironmentObject private var studyStore: StudyFeatureStore

    @State private var playbackRate: Float = 1.0
    @State private var currentTime: Double = 0.0
    @State private var isPlaying: Bool = false
    @State private var studyNotes: String = ""
    @State private var lessonCompleted: Bool = false
    @State private var userRating: Int = 0
    @State private var showRating: Bool = false

    private let playbackTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var lessonId: String
    var courseId: String
    var lessonName: String
    var totalDuration: Double = 24.0

    var completionPercentage: Double {
        guard totalDuration > 0 else { return 0 }
        return min(currentTime / totalDuration, 1.0)
    }

    var timeString: String {
        let minutes = Int(currentTime) / 60
        let seconds = Int(currentTime) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }

    var totalTimeString: String {
        let minutes = Int(totalDuration) / 60
        let seconds = Int(totalDuration) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }

    var body: some View {
        ZStack {
            Color(.systemBackground).ignoresSafeArea()

            VStack(spacing: 0) {
                LessonHeaderView(dismiss: dismiss)

                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 0) {
                        VideoPlayerSection(
                            isPlaying: $isPlaying,
                            currentTime: currentTime,
                            totalTimeString: totalTimeString,
                            timeString: timeString,
                            completionPercentage: completionPercentage
                        )

                        LessonTitleSection(lessonName: lessonName)

                        PlaybackSpeedSection(playbackRate: $playbackRate)

                        LearningJourneyCard(completionPercentage: completionPercentage)

                        LessonStudyToolsSection(
                            courseId: courseId,
                            lessonId: lessonId,
                            lessonName: lessonName
                        )

                        StudyNotesSection(studyNotes: $studyNotes)

                        MarkCompleteButton(
                            lessonCompleted: $lessonCompleted,
                            showRating: $showRating,
                            persistenceManager: persistenceManager,
                            lessonId: lessonId,
                            courseId: courseId,
                            studyNotes: studyNotes
                        )

                        if showRating {
                            LessonRatingView(
                                rating: $userRating,
                                lessonId: lessonId,
                                persistenceManager: persistenceManager,
                                dismiss: dismiss
                            )
                        }
                    }
                }
            }
        }
        .onAppear {
            persistenceManager.updateUserStreak()

            if let existing = persistenceManager.getLessonProgress(for: lessonId) {
                lessonCompleted = existing.isCompleted
                if !existing.notes.isEmpty {
                    studyNotes = existing.notes
                }
                currentTime = existing.watchedDuration
                userRating = existing.rating
                if existing.isCompleted && existing.rating > 0 {
                    showRating = true
                }
            } else {
                let progress = LessonProgress(
                    lessonId: lessonId,
                    courseId: courseId,
                    lessonName: lessonName,
                    totalDuration: totalDuration
                )
                persistenceManager.saveLessonProgress(progress)
            }
        }
        .onReceive(playbackTimer) { _ in
            guard isPlaying, !lessonCompleted else { return }

            if currentTime < totalDuration {
                currentTime = min(currentTime + Double(playbackRate), totalDuration)
            } else {
                isPlaying = false
            }
        }
        .onChange(of: currentTime) { _, newValue in
            persistenceManager.updateLessonProgress(
                lessonId: lessonId,
                watchedDuration: newValue,
                totalDuration: totalDuration
            )
        }
        .onChange(of: studyNotes) { _, newValue in
            persistenceManager.saveLessonNotes(lessonId: lessonId, notes: newValue)
        }
        .onChange(of: lessonCompleted) { _, newValue in
            if newValue {
                studyStore.recordCourseProgress()
            }
        }
    }
}

// MARK: - Header

struct LessonHeaderView: View {
    let dismiss: DismissAction
    @State private var showSettings: Bool = false

    var body: some View {
        HStack {
            Button(action: { dismiss() }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.gray.opacity(0.6))
                    .frame(width: 40, height: 40)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.gray.opacity(0.1))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray.opacity(0.15), lineWidth: 2)
                    )
            }

            Text("CLASSROOM")
                .font(.system(size: 14, weight: .black))
                .tracking(0.5)
                .foregroundStyle(Color(.label).opacity(0.85))

            Spacer()

            Button(action: { showSettings = true }) {
                Image(systemName: "gear")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.gray.opacity(0.6))
                    .frame(width: 40, height: 40)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.gray.opacity(0.1))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray.opacity(0.15), lineWidth: 2)
                    )
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color(.systemBackground).opacity(0.9))
        .overlay(alignment: .bottom) {
            Divider()
        }
        .sheet(isPresented: $showSettings) {
            LessonSettingsSheet()
        }
    }
}

struct LessonSettingsSheet: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var persistenceManager = DataPersistenceManager.shared
    @State private var autoPlay: Bool = true
    @State private var quality: String = "High"

    var body: some View {
        NavigationStack {
            Form {
                Section("Playback") {
                    Toggle("Auto-play next lesson", isOn: $autoPlay)
                    Picker("Video Quality", selection: $quality) {
                        Text("Low").tag("Low")
                        Text("Medium").tag("Medium")
                        Text("High").tag("High")
                    }
                }

                Section("About") {
                    HStack {
                        Text("App Version")
                        Spacer()
                        Text("1.0").foregroundStyle(.gray)
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
            .onAppear {
                let prefs = persistenceManager.loadPreferences()
                autoPlay = prefs.autoPlayEnabled
                quality = prefs.playbackQuality
            }
        }
    }
}

// MARK: - Video

struct VideoPlayerSection: View {
    @Binding var isPlaying: Bool
    let currentTime: Double
    let totalTimeString: String
    let timeString: String
    let completionPercentage: Double

    var body: some View {
        ZStack(alignment: .bottom) {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(red: 0.176, green: 0.22, blue: 0.29))

            Image(systemName: "film.stack.fill")
                .font(.system(size: 120))
                .foregroundStyle(Color.blue.opacity(0.2))
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)

            LinearGradient(
                gradient: Gradient(colors: [
                    Color.black.opacity(0.2),
                    Color.black.opacity(0.6)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )

            Button(action: { isPlaying.toggle() }) {
                Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                    .font(.system(size: 30, weight: .bold))
                    .foregroundStyle(Color(.label).opacity(0.9))
                    .frame(width: 80, height: 80)
                    .background(Circle().fill(Color(red: 0.99, green: 0.88, blue: 0.28)))
                    .shadow(radius: 8)
            }

            ProgressBarView(
                completionPercentage: completionPercentage,
                timeString: timeString,
                totalTimeString: totalTimeString
            )
        }
        .frame(height: 240)
        .padding(16)
    }
}

struct ProgressBarView: View {
    let completionPercentage: Double
    let timeString: String
    let totalTimeString: String

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 8) {
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Color.white.opacity(0.25))
                            .frame(height: 8)

                        Capsule()
                            .fill(Color(red: 0.99, green: 0.88, blue: 0.28))
                            .frame(width: geo.size.width * completionPercentage, height: 8)
                    }
                }
                .frame(height: 8)

                ZStack {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 16, height: 16)
                        .shadow(radius: 4)

                    Circle()
                        .fill(Color(red: 0.99, green: 0.88, blue: 0.28))
                        .frame(width: 8, height: 8)
                }
            }

            HStack {
                Text(timeString)
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(.white)

                Spacer()

                Text(totalTimeString)
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(.white)
            }
            .padding(.top, 6)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}

// MARK: - Title / Playback / Progress

struct LessonTitleSection: View {
    let lessonName: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "school.badge.fill")
                    .font(.system(size: 12))
                    .foregroundStyle(Color.blue)

                Text("UNIVERSITY ACCESS")
                    .font(.system(size: 9, weight: .black))
                    .tracking(0.4)
                    .foregroundStyle(Color.blue)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(Color.blue.opacity(0.15))
            .cornerRadius(12)

            Text(lessonName)
                .font(.system(size: 28, weight: .black))
                .foregroundStyle(Color(.label).opacity(0.9))
                .lineLimit(3)

            Text("Lesson in progress")
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(.gray.opacity(0.6))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
        .padding(.bottom, 16)
    }
}

struct PlaybackSpeedSection: View {
    @Binding var playbackRate: Float

    private let speeds: [Float] = [0.5, 1.0, 1.25, 1.5, 2.0]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Playback Speed")
                .font(.system(size: 16, weight: .black))
                .foregroundStyle(Color(.label).opacity(0.9))

            Picker("Playback Speed", selection: $playbackRate) {
                ForEach(speeds, id: \.self) { speed in
                    Text(label(for: speed)).tag(speed)
                }
            }
            .pickerStyle(.segmented)
        }
        .padding(16)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.gray.opacity(0.2), lineWidth: 2)
        )
        .padding(.horizontal, 20)
        .padding(.bottom, 16)
    }

    private func label(for speed: Float) -> String {
        switch speed {
        case 0.5: return "0.5x"
        case 1.0: return "1x"
        case 1.25: return "1.25x"
        case 1.5: return "1.5x"
        case 2.0: return "2x"
        default: return "\(speed)x"
        }
    }
}

struct LearningJourneyCard: View {
    let completionPercentage: Double

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Learning Journey")
                    .font(.system(size: 13, weight: .black))
                    .foregroundStyle(Color(.label).opacity(0.85))

                Spacer()

                Text("\(Int(completionPercentage * 100))% COMPLETED")
                    .font(.system(size: 11, weight: .black))
                    .foregroundStyle(Color.green)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.green.opacity(0.15))
                    .cornerRadius(6)
            }

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.gray.opacity(0.1))

                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(red: 0.231, green: 0.51, blue: 0.96))
                        .frame(width: geo.size.width * completionPercentage)
                }
            }
            .frame(height: 16)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            )
        }
        .padding(16)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.gray.opacity(0.2), lineWidth: 2)
        )
        .padding(.horizontal, 20)
        .padding(.bottom, 16)
    }
}

// MARK: - Study Tools

struct LessonStudyToolsSection: View {
    let courseId: String
    let lessonId: String
    let lessonName: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Study Tools")
                .font(.system(size: 16, weight: .black))
                .foregroundStyle(Color(.label).opacity(0.9))

            NavigationLink {
                LessonFlashcardsView(
                    courseId: courseId,
                    lessonId: lessonId,
                    lessonTitle: lessonName
                )
            } label: {
                HStack {
                    Image(systemName: "rectangle.stack.fill")
                    Text("Flashcards")
                        .fontWeight(.bold)
                    Spacer()
                    Image(systemName: "chevron.right")
                }
                .foregroundStyle(.white)
                .padding()
                .background(Color.blue)
                .cornerRadius(14)
            }

            NavigationLink {
                LessonStudyTimerView(
                    courseId: courseId,
                    courseTitle: lessonName
                )
            } label: {
                HStack {
                    Image(systemName: "timer")
                    Text("Study Timer / Pomodoro")
                        .fontWeight(.bold)
                    Spacer()
                    Image(systemName: "chevron.right")
                }
                .foregroundStyle(.blue)
                .padding()
                .background(Color.blue.opacity(0.1))
                .cornerRadius(14)
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 16)
    }
}

struct LessonFlashcardsView: View {
    let courseId: String
    let lessonId: String
    let lessonTitle: String

    @EnvironmentObject private var studyStore: StudyFeatureStore

    @State private var deckId: String = ""
    @State private var frontText: String = ""
    @State private var backText: String = ""
    @State private var currentIndex: Int = 0
    @State private var showAnswer: Bool = false

    private var cards: [Flashcard] {
        studyStore.flashcardDecks.first(where: { $0.id == deckId })?.cards ?? []
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Create Flashcard")
                        .font(.title3.bold())

                    TextField("Front", text: $frontText)
                        .textFieldStyle(.roundedBorder)

                    TextField("Back", text: $backText)
                        .textFieldStyle(.roundedBorder)

                    Button("Add Flashcard") {
                        studyStore.addFlashcard(
                            courseId: courseId,
                            lessonId: lessonId,
                            title: lessonTitle,
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
                .background(Color(.secondarySystemBackground))
                .cornerRadius(16)

                if cards.isEmpty {
                    ContentUnavailableView(
                        "No Flashcards Yet",
                        systemImage: "rectangle.stack.badge.plus",
                        description: Text("Create cards for this lesson.")
                    )
                } else {
                    VStack(spacing: 16) {
                        Text("Card \(currentIndex + 1) of \(cards.count)")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)

                        VStack(spacing: 14) {
                            Text(cards[currentIndex].front)
                                .font(.title3.bold())
                                .multilineTextAlignment(.center)

                            if showAnswer {
                                Divider()
                                Text(cards[currentIndex].back)
                                    .multilineTextAlignment(.center)
                            }
                        }
                        .frame(maxWidth: .infinity, minHeight: 220)
                        .padding()
                        .background(Color.blue.opacity(0.08))
                        .cornerRadius(18)

                        Button(showAnswer ? "Hide Answer" : "Show Answer") {
                            showAnswer.toggle()
                        }
                        .buttonStyle(.bordered)

                        if showAnswer {
                            HStack {
                                Button("Again") {
                                    studyStore.markFlashcardResult(
                                        deckId: deckId,
                                        cardId: cards[currentIndex].id,
                                        correct: false
                                    )
                                    moveNext()
                                }
                                .buttonStyle(.bordered)

                                Button("Got It") {
                                    studyStore.markFlashcardResult(
                                        deckId: deckId,
                                        cardId: cards[currentIndex].id,
                                        correct: true
                                    )
                                    moveNext()
                                }
                                .buttonStyle(.borderedProminent)
                            }
                        }

                        ForEach(cards) { card in
                            VStack(alignment: .leading, spacing: 6) {
                                Text(card.front)
                                    .font(.headline)

                                Text(card.back)
                                    .foregroundStyle(.secondary)

                                Text("Correct: \(card.correctCount) · Again: \(card.incorrectCount)")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(14)
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Flashcards")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if deckId.isEmpty {
                let deck = studyStore.deck(for: courseId, lessonId: lessonId, title: lessonTitle)
                deckId = deck.id
            }
        }
    }

    private func moveNext() {
        showAnswer = false
        guard !cards.isEmpty else { return }
        currentIndex = (currentIndex + 1) % cards.count
    }
}

struct LessonStudyTimerView: View {
    let courseId: String
    let courseTitle: String

    @EnvironmentObject private var studyStore: StudyFeatureStore

    @State private var focusMinutes: Int = 25
    @State private var breakMinutes: Int = 5
    @State private var secondsRemaining: Int = 25 * 60
    @State private var isRunning: Bool = false
    @State private var showFinishedAlert: Bool = false

    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack(spacing: 24) {
            Text(courseTitle)
                .font(.title3.bold())
                .multilineTextAlignment(.center)

            Text(timeString(from: secondsRemaining))
                .font(.system(size: 56, weight: .bold, design: .rounded))
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
            .background(Color(.secondarySystemBackground))
            .cornerRadius(16)

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

            Text("Completed sessions are saved to your analytics.")
                .font(.footnote)
                .foregroundStyle(.secondary)

            Spacer()
        }
        .padding()
        .navigationTitle("Study Timer")
        .navigationBarTitleDisplayMode(.inline)
        .onReceive(timer) { _ in
            guard isRunning else { return }

            if secondsRemaining > 0 {
                secondsRemaining -= 1
            } else {
                isRunning = false
                showFinishedAlert = true
                studyStore.recordStudySession(
                    courseId: courseId,
                    courseTitle: courseTitle,
                    focusMinutes: focusMinutes,
                    breakMinutes: breakMinutes
                )
                secondsRemaining = focusMinutes * 60
            }
        }
        .onDisappear {
            isRunning = false
        }
        .alert("Pomodoro Completed", isPresented: $showFinishedAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Your study session has been saved.")
        }
    }

    private func timeString(from totalSeconds: Int) -> String {
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

// MARK: - Notes

struct StudyNotesSection: View {
    @Binding var studyNotes: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "note.text")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(Color(.label).opacity(0.85))

                Text("Study Notes")
                    .font(.system(size: 16, weight: .black))
                    .foregroundStyle(Color(.label).opacity(0.9))

                Spacer()
            }
            .padding(.horizontal, 12)

            NotebookView(studyNotes: $studyNotes)
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 24)
    }
}

struct NotebookView: View {
    @Binding var studyNotes: String
    @State private var noteColor: Color = .black
    @State private var showColorPicker: Bool = false

    let noteColors: [Color] = [.black, .blue, .red, .green, .purple, .orange]

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: 0) {
                    VStack(spacing: 24) {
                        ForEach(0..<8, id: \.self) { _ in
                            Circle()
                                .fill(Color.gray.opacity(0.2))
                                .frame(width: 8, height: 8)
                                .overlay(
                                    Circle()
                                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                )
                        }
                    }
                    .padding(.leading, 12)
                    .padding(.trailing, 8)
                    .padding(.top, 12)

                    Rectangle()
                        .fill(Color.red.opacity(0.3))
                        .frame(width: 2)
                        .padding(.vertical, 4)

                    TextEditor(text: $studyNotes)
                        .font(.system(size: 16, design: .monospaced))
                        .foregroundStyle(noteColor.opacity(0.8))
                        .scrollContentBackground(.hidden)
                        .padding(.leading, 8)
                        .padding(.top, 4)
                }
            }
            .frame(minHeight: 200)
            .background(Color(.secondarySystemBackground))

            VStack(spacing: 8) {
                Button(action: { showColorPicker.toggle() }) {
                    Image(systemName: "paintpalette.fill")
                        .font(.system(size: 14))
                        .foregroundStyle(noteColor)
                        .frame(width: 32, height: 32)
                        .background(RoundedRectangle(cornerRadius: 12).fill(Color.white))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.gray.opacity(0.2), lineWidth: 2)
                        )
                }

                Button(action: {
                    let timestamp = DateFormatter.localizedString(
                        from: Date(),
                        dateStyle: .none,
                        timeStyle: .short
                    )
                    studyNotes += "\n[\(timestamp)] "
                }) {
                    Image(systemName: "clock.badge.fill")
                        .font(.system(size: 14))
                        .foregroundStyle(.gray.opacity(0.6))
                        .frame(width: 32, height: 32)
                        .background(RoundedRectangle(cornerRadius: 12).fill(Color.white))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.gray.opacity(0.2), lineWidth: 2)
                        )
                }

                if showColorPicker {
                    VStack(spacing: 6) {
                        ForEach(noteColors, id: \.self) { color in
                            Button(action: {
                                noteColor = color
                                showColorPicker = false
                            }) {
                                Circle()
                                    .fill(color)
                                    .frame(width: 24, height: 24)
                                    .overlay(
                                        Circle()
                                            .stroke(noteColor == color ? Color.white : Color.clear, lineWidth: 2)
                                    )
                                    .shadow(radius: noteColor == color ? 2 : 0)
                            }
                        }
                    }
                    .padding(8)
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color.white))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                    )
                    .shadow(radius: 4)
                }
            }
            .padding(12)
        }
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.gray.opacity(0.2), lineWidth: 2)
        )
        .shadow(radius: 8)
    }
}

// MARK: - Complete / Rating

struct MarkCompleteButton: View {
    @Binding var lessonCompleted: Bool
    @Binding var showRating: Bool
    let persistenceManager: DataPersistenceManager
    let lessonId: String
    let courseId: String
    let studyNotes: String

    var body: some View {
        Button(action: {
            persistenceManager.markLessonAsComplete(lessonId: lessonId)
            persistenceManager.saveLessonNotes(lessonId: lessonId, notes: studyNotes)

            let completedCount = persistenceManager.getCompletedModuleIds(for: courseId).count

            if let courseProgress = persistenceManager.getCourseProgress(for: courseId) {
                let total = courseProgress.totalLessons
                let percentage = total > 0
                    ? (Double(completedCount) / Double(total)) * 100.0
                    : 0

                persistenceManager.updateCourseProgress(
                    courseId: courseId,
                    completionPercentage: percentage,
                    lessonsCompleted: completedCount
                )
            }

            lessonCompleted = true
            showRating = true
        }) {
            HStack(spacing: 12) {
                Image(systemName: lessonCompleted ? "checkmark.circle.fill" : "checkmark.circle")
                    .font(.system(size: 20))

                Text(lessonCompleted ? "COMPLETED" : "MARK AS COMPLETE")
                    .font(.system(size: 16, weight: .black))
                    .tracking(0.3)
            }
            .frame(maxWidth: .infinity)
            .foregroundStyle(.white)
            .padding(.vertical, 16)
            .background(
                Color(
                    red: lessonCompleted ? 0.2 : 0.231,
                    green: lessonCompleted ? 0.6 : 0.51,
                    blue: 0.4
                )
            )
            .cornerRadius(16)
            .shadow(
                color: Color(red: 0.231, green: 0.51, blue: 0.96).opacity(0.3),
                radius: 8,
                x: 0,
                y: 4
            )
            .overlay(alignment: .bottom) {
                RoundedRectangle(cornerRadius: 16)
                    .frame(height: 4)
                    .foregroundStyle(Color(red: 0.15, green: 0.35, blue: 0.8))
                    .offset(y: 20)
            }
        }
        .disabled(lessonCompleted)
        .opacity(lessonCompleted ? 0.7 : 1.0)
        .padding(.horizontal, 24)
        .padding(.vertical, 24)
    }
}

struct LessonRatingView: View {
    @Binding var rating: Int
    let lessonId: String
    let persistenceManager: DataPersistenceManager
    let dismiss: DismissAction

    var body: some View {
        VStack(spacing: 16) {
            Text("Rate This Lesson")
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundStyle(Color(.label).opacity(0.85))

            HStack(spacing: 12) {
                ForEach(1...5, id: \.self) { star in
                    Button(action: {
                        rating = star
                        persistenceManager.rateLessonProgress(lessonId: lessonId, rating: star)
                    }) {
                        Image(systemName: star <= rating ? "star.fill" : "star")
                            .font(.system(size: 32))
                            .foregroundStyle(star <= rating ? Color.yellow : Color.gray.opacity(0.3))
                    }
                }
            }

            if rating > 0 {
                Text(ratingLabel)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.gray.opacity(0.6))

                Button(action: { dismiss() }) {
                    Text("Done")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 32)
                        .padding(.vertical, 10)
                        .background(Color.blue)
                        .cornerRadius(12)
                }
                .padding(.top, 4)
            }
        }
        .padding(20)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.gray.opacity(0.2), lineWidth: 2)
        )
        .padding(.horizontal, 24)
        .padding(.bottom, 24)
    }

    var ratingLabel: String {
        switch rating {
        case 1: return "Needs Improvement"
        case 2: return "Fair"
        case 3: return "Good"
        case 4: return "Great!"
        case 5: return "Excellent!"
        default: return ""
        }
    }
}

#Preview {
    NavigationStack {
        LessonView(
            lessonId: "psy_mod_1",
            courseId: "course_intro_psychology",
            lessonName: "1. Foundations of Behavior"
        )
        .environmentObject(StudyFeatureStore.shared)
    }
}
