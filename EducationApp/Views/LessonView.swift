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

    let lessonId: String = "lesson_2_cognitive_processes"
    let courseId: String = "course_introduction_psychology"
    let lessonName: String = "2. Cognitive Processes"
    let totalDuration: Double = 24.0
    let completionPercentage: Double = 0.65

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
                // Header
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

                    Button(action: {}) {
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

                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 0) {
                        // Video Player
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

                            // Play Button
                            Button(action: { isPlaying.toggle() }) {
                                Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                                    .font(.system(size: 30, weight: .bold))
                                    .foregroundStyle(.black.opacity(0.9))
                                    .frame(width: 80, height: 80)
                                    .background(Circle().fill(Color(red: 0.99, green: 0.88, blue: 0.28)))
                                    .shadow(radius: 8)
                            }

                            // Progress Bar Section
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
                        .frame(height: 240)
                        .padding(16)

                        // Badge and Title Section
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

                            Text("The History of Cognition")
                                .font(.system(size: 28, weight: .black))
                                .foregroundStyle(.black.opacity(0.9))
                                .lineLimit(3)

                            Text("Module 1: Foundations of Mind")
                                .font(.system(size: 13, weight: .medium))
                                .foregroundStyle(.gray.opacity(0.6))
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 16)

                        // Learning Journey Card
                        VStack(spacing: 12) {
                            HStack {
                                Text("Learning Journey")
                                    .font(.system(size: 13, weight: .black))
                                    .foregroundStyle(.black.opacity(0.85))

                                Spacer()

                                Text("65% COMPLETED")
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

                        // Study Notes Section
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

                            // Notebook Paper
                            ZStack(alignment: .bottomTrailing) {
                                VStack(alignment: .leading, spacing: 0) {
                                    // Left margin with dots
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
                                        .padding(.left, 12)
                                        .padding(.right, 20)
                                        .padding(.top, 12)

                                        // Notebook lines
                                        VStack(spacing: 0) {
                                            ForEach(0..<8, id: \.self) { _ in
                                                HStack(spacing: 0) {
                                                    Text("")
                                                        .frame(height: 32)

                                                    Divider()
                                                        .frame(height: 1)
                                                        .background(Color.gray.opacity(0.2))
                                                }
                                            }
                                        }

                                        Spacer()
                                    }

                                    Spacer()
                                }
                                .frame(minHeight: 200)
                                .overlay(alignment: .topLeading) {
                                    Text(studyNotes)
                                        .font(.system(size: 16))
                                        .fontDesign(.monospaced)
                                        .foregroundStyle(.black.opacity(0.8))
                                        .padding(.left, 60)
                                        .padding(.top, 12)
                                }
                                .background(Color.white)

                                // Right margin line
                                VStack {
                                    Divider()
                                        .frame(width: 2)
                                        .background(Color.red.opacity(0.3))
                                }
                                .frame(width: 2)
                                .padding(.right, 12)

                                // Buttons
                                VStack(spacing: 8) {
                                    Button(action: {}) {
                                        Image(systemName: "paintpalette.fill")
                                            .font(.system(size: 14))
                                            .foregroundStyle(.gray.opacity(0.6))
                                            .frame(width: 32, height: 32)
                                            .background(RoundedRectangle(cornerRadius: 12).fill(Color.white))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .stroke(Color.gray.opacity(0.2), lineWidth: 2)
                                            )
                                    }

                                    Button(action: {}) {
                                        Image(systemName: "paperclip")
                                            .font(.system(size: 14))
                                            .foregroundStyle(.gray.opacity(0.6))
                                            .frame(width: 32, height: 32)
                                            .background(RoundedRectangle(cornerRadius: 12).fill(Color.white))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .stroke(Color.gray.opacity(0.2), lineWidth: 2)
                                            )
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
                        .padding(.horizontal, 16)
                        .padding(.bottom, 24)

                        // Mark Complete Button
                        Button(action: {
                            persistenceManager.markLessonAsComplete(lessonId: lessonId)
                            persistenceManager.saveLessonNotes(lessonId: lessonId, notes: studyNotes)
                            lessonCompleted = true
                            showCompletionMessage = true

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
            }
        }
        .onAppear {
            if let existing = persistenceManager.getLessonProgress(for: lessonId) {
                lessonCompleted = existing.isCompleted
                studyNotes = existing.notes
            }
        }
        .onChange(of: currentTime) {
            persistenceManager.updateLessonProgress(
                lessonId: lessonId,
                watchedDuration: currentTime,
                totalDuration: totalDuration
            )
        }
    }
}

#Preview {
    NavigationStack {
        LessonView()
    }
}
