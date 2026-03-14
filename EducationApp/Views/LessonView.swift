import SwiftUI

struct LessonView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var persistenceManager = DataPersistenceManager.shared

    @State private var currentTime: Double = 12.75
    @State private var isPlaying: Bool = false
    @State private var studyNotes: String = "Aristotle's Tabula Rasa...\nThe behaviorist movement in the 1920s..."
    @State private var showNotesEditor: Bool = false
    @State private var lessonCompleted: Bool = false
    @State private var showCompletionMessage: Bool = false

    var lessonId: String = "lesson_2_cognitive_processes"
    var courseId: String = "course_introduction_psychology"
    var lessonName: String = "2. Cognitive Processes"
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
            Color(red: 0.97, green: 0.98, blue: 0.99).ignoresSafeArea()

            VStack(spacing: 0) {
                LessonHeaderView(dismiss: dismiss)

                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 0) {
                        VideoPlayerSection(isPlaying: $isPlaying, currentTime: currentTime, totalTimeString: totalTimeString, timeString: timeString, completionPercentage: completionPercentage)

                        LessonTitleSection(lessonName: lessonName)

                        LearningJourneyCard(completionPercentage: completionPercentage)

                        StudyNotesSection(studyNotes: $studyNotes)

                        MarkCompleteButton(lessonCompleted: $lessonCompleted, persistenceManager: persistenceManager, lessonId: lessonId, courseId: courseId, studyNotes: studyNotes, dismiss: dismiss)
                    }
                }
            }
        }
        .onAppear {
            if let existing = persistenceManager.getLessonProgress(for: lessonId) {
                lessonCompleted = existing.isCompleted
                if !existing.notes.isEmpty {
                    studyNotes = existing.notes
                }
                currentTime = existing.watchedDuration
            } else {
                // Create initial lesson progress with courseId
                let progress = LessonProgress(
                    lessonId: lessonId,
                    courseId: courseId,
                    lessonName: lessonName,
                    totalDuration: totalDuration
                )
                persistenceManager.saveLessonProgress(progress)
            }
        }
        .onChange(of: currentTime) {
            persistenceManager.updateLessonProgress(
                lessonId: lessonId,
                watchedDuration: currentTime,
                totalDuration: totalDuration
            )
        }
        .onChange(of: studyNotes) {
            persistenceManager.saveLessonNotes(lessonId: lessonId, notes: studyNotes)
        }
    }
}

// MARK: - Subviews

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
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color.gray.opacity(0.1)))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray.opacity(0.15), lineWidth: 2)
                    )
            }

            Text("CLASSROOM")
                .font(.system(size: 14, weight: .black))
                .tracking(0.5)
                .foregroundStyle(.black.opacity(0.85))

            Spacer()

            Button(action: { showSettings = true }) {
                Image(systemName: "gear")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.gray.opacity(0.6))
                    .frame(width: 40, height: 40)
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color.gray.opacity(0.1)))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray.opacity(0.15), lineWidth: 2)
                    )
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color.white.opacity(0.8))
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
                    .foregroundStyle(.black.opacity(0.9))
                    .frame(width: 80, height: 80)
                    .background(Circle().fill(Color(red: 0.99, green: 0.88, blue: 0.28)))
                    .shadow(radius: 8)
            }

            ProgressBarView(completionPercentage: completionPercentage, timeString: timeString, totalTimeString: totalTimeString)
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
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color(red: 0.99, green: 0.88, blue: 0.28))
                        .frame(height: 8)

                    Capsule()
                        .fill(Color.white.opacity(0.3))
                        .frame(width: CGFloat(175 * (1 - completionPercentage)), height: 8)
                }

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
                .foregroundStyle(.black.opacity(0.9))
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

struct LearningJourneyCard: View {
    let completionPercentage: Double

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Learning Journey")
                    .font(.system(size: 13, weight: .black))
                    .foregroundStyle(.black.opacity(0.85))

                Spacer()

                Text("\(Int(completionPercentage * 100))% COMPLETED")
                    .font(.system(size: 11, weight: .black))
                    .foregroundStyle(Color.green)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.green.opacity(0.15))
                    .cornerRadius(6)
            }

            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.1))

                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(red: 0.231, green: 0.51, blue: 0.96))
                    .frame(width: CGFloat(250 * completionPercentage), alignment: .leading)
            }
            .frame(height: 16)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            )
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.gray.opacity(0.2), lineWidth: 2)
        )
        .padding(.horizontal, 20)
        .padding(.bottom, 16)
    }
}

struct StudyNotesSection: View {
    @Binding var studyNotes: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "note.text")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(.black.opacity(0.85))

                Text("Study Notes")
                    .font(.system(size: 16, weight: .black))
                    .foregroundStyle(.black.opacity(0.9))

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
                    // Spiral binding dots
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
                    .padding(.left, 12)
                    .padding(.right, 8)
                    .padding(.top, 12)

                    // Red margin line
                    Rectangle()
                        .fill(Color.red.opacity(0.3))
                        .frame(width: 2)
                        .padding(.vertical, 4)

                    // Editable text area
                    TextEditor(text: $studyNotes)
                        .font(.system(size: 16, design: .monospaced))
                        .foregroundStyle(noteColor.opacity(0.8))
                        .scrollContentBackground(.hidden)
                        .padding(.leading, 8)
                        .padding(.top, 4)
                }
            }
            .frame(minHeight: 200)
            .background(Color.white)

            // Tool buttons
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
                    let timestamp = DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .short)
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

struct MarkCompleteButton: View {
    @Binding var lessonCompleted: Bool
    let persistenceManager: DataPersistenceManager
    let lessonId: String
    let courseId: String
    let studyNotes: String
    let dismiss: DismissAction

    var body: some View {
        Button(action: {
            persistenceManager.markLessonAsComplete(lessonId: lessonId)
            persistenceManager.saveLessonNotes(lessonId: lessonId, notes: studyNotes)

            // Update course progress
            let completedCount = persistenceManager.getCompletedModuleIds(for: courseId).count
            if let courseProgress = persistenceManager.getCourseProgress(for: courseId) {
                let total = courseProgress.totalLessons
                let percentage = total > 0 ? (Double(completedCount) / Double(total)) * 100.0 : 0
                persistenceManager.updateCourseProgress(
                    courseId: courseId,
                    completionPercentage: percentage,
                    lessonsCompleted: completedCount
                )
            }

            lessonCompleted = true

            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                dismiss()
            }
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
            .background(Color(red: lessonCompleted ? 0.2 : 0.231, green: lessonCompleted ? 0.6 : 0.51, blue: 0.4))
            .cornerRadius(16)
            .shadow(color: Color(red: 0.231, green: 0.51, blue: 0.96).opacity(0.3), radius: 8, x: 0, y: 4)
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

#Preview {
    NavigationStack {
        LessonView()
    }
}
