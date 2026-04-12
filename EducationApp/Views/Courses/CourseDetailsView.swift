import SwiftUI

struct CourseDetailsView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var persistenceManager = DataPersistenceManager.shared

    let courseId: String
    let title: String
    let category: String
    let duration: String
    let studentCount: String
    let rating: String
    let reviewsCount: String
    let instructor: String
    let instructorDept: String

    var body: some View {
        // Calculate progress state
        let lesson1Id = "\(courseId)_lesson_1"
        let isL1Completed = persistenceManager.getLessonProgress(for: lesson1Id)?.isCompleted ?? false
        
        let lesson2Id = "\(courseId)_lesson_2"
        let isL2Completed = persistenceManager.getLessonProgress(for: lesson2Id)?.isCompleted ?? false
        
        let quizId = "\(courseId)_quiz"
        let isQuizCompleted = persistenceManager.getLessonProgress(for: quizId)?.isCompleted ?? false
        
        // Check if entire course is completed
        let isCourseFullyCompleted = isL1Completed && isL2Completed && isQuizCompleted

        ZStack {
            Color.white.ignoresSafeArea()

            // Main Content
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.gray.opacity(0.6))
                            .frame(width: 40, height: 40)
                            .background(Circle().fill(Color.gray.opacity(0.05)))
                    }
                    Spacer()
                    Text("Syllabus Overview")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(.gray.opacity(0.8))
                    Spacer()
                    Button(action: {}) {
                        Image(systemName: "bookmark")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.gray.opacity(0.6))
                            .frame(width: 40, height: 40)
                    }
                }
                .padding(.horizontal, 12).padding(.vertical, 8)
                .background(Color.white.opacity(0.9))
                .overlay(alignment: .bottom) { Divider() }

                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 0) {
                        // Hero Image Section
                        ZStack(alignment: .bottomLeading) {
                            Image(systemName: "book.circle.fill")
                                .font(.system(size: 200))
                                .foregroundStyle(Color.blue.opacity(0.1))
                                .frame(maxWidth: .infinity, alignment: .trailing)
                            
                            LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0.8), Color.black.opacity(0.2), Color.clear]), startPoint: .bottom, endPoint: .top)
                            
                            VStack(alignment: .leading, spacing: 12) {
                                HStack(spacing: 8) {
                                    Image(systemName: "checkmark.seal.fill")
                                        .font(.system(size: 10))
                                        .foregroundStyle(Color(red: 1, green: 0.84, blue: 0))
                                    Text(".EDU VERIFIED COURSE")
                                        .font(.system(size: 9, weight: .bold))
                                        .tracking(0.8)
                                        .foregroundStyle(.white)
                                }
                                .padding(.horizontal, 12).padding(.vertical, 6)
                                .background(Color.white.opacity(0.2)).cornerRadius(12)
                                
                                Text(title)
                                    .font(.system(size: 28, weight: .bold, design: .default))
                                    .foregroundStyle(.white)
                                    .lineLimit(3)
                            }
                            .padding(20)
                        }
                        .frame(height: 280).background(Color.blue.opacity(0.1)).cornerRadius(32).padding(20)

                        // Stats Section
                        HStack(spacing: 0) {
                            statItem(icon: "star.fill", iconColor: Color(red: 1, green: 0.84, blue: 0), value: rating, sub: "(\(reviewsCount) reviews)")
                            Divider().frame(height: 16)
                            statItem(icon: "person.2.fill", iconColor: .gray.opacity(0.5), value: studentCount, sub: "Students")
                            Divider().frame(height: 16)
                            statItem(icon: "clock.fill", iconColor: .gray.opacity(0.5), value: duration, sub: "Total")
                        }
                        .padding(.horizontal, 20).padding(.vertical, 12)
                        .background(Color.blue.opacity(0.03))
                        .overlay(VStack { Divider(); Spacer(); Divider() })
                        .padding(.bottom, 12)

                        // Instructor Section
                        HStack(spacing: 12) {
                            Image(systemName: "person.crop.circle.fill")
                                .font(.system(size: 48))
                                .foregroundStyle(Color.blue.opacity(0.3))
                                .frame(width: 56, height: 56)
                                .background(RoundedRectangle(cornerRadius: 16).fill(Color.gray.opacity(0.1)))
                                .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.white, lineWidth: 4)).shadow(radius: 4)
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text("INSTRUCTOR")
                                    .font(.system(size: 9, weight: .bold))
                                    .tracking(0.5)
                                    .foregroundStyle(Color(red: 0.176, green: 0.357, blue: 0.94))
                                Text(instructor)
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundStyle(.black.opacity(0.9))
                                Text(instructorDept)
                                    .font(.system(size: 11))
                                    .foregroundStyle(.gray.opacity(0.55))
                            }
                            Spacer()
                            Button(action: {}) {
                                Text("Profile")
                                    .font(.system(size: 11, weight: .bold))
                                    .padding(.horizontal, 12).padding(.vertical, 8)
                                    .background(RoundedRectangle(cornerRadius: 12).fill(Color.white).shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1))
                            }
                        }
                        .padding(16).background(Color.gray.opacity(0.03)).cornerRadius(20)
                        .padding(.horizontal, 20).padding(.bottom, 24)

                        // Course Modules Section
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Course Modules")
                                .font(.system(size: 18, weight: .bold, design: .default))
                                .padding(.horizontal, 20)
                            
                            VStack(spacing: 12) {
                                // Lesson 1
                                NavigationLink(destination: LessonView(lessonId: lesson1Id, courseId: courseId, lessonTitle: title, moduleName: "1. Foundations", totalDuration: 720.0).navigationBarHidden(true)) {
                                    CourseModuleCard(icon: isL1Completed ? "checkmark.circle.fill" : "play.fill", iconColor: isL1Completed ? .green : .white, backgroundColor: isL1Completed ? .green.opacity(0.05) : Color(red: 0.176, green: 0.357, blue: 0.94).opacity(0.08), borderColor: isL1Completed ? .green.opacity(0.2) : Color(red: 0.176, green: 0.357, blue: 0.94).opacity(0.2), title: "1. Foundations", subtitle: "12 mins", isCompleted: isL1Completed, isCurrent: !isL1Completed, isLocked: false)
                                }

                                // Lesson 2
                                NavigationLink(destination: LessonView(lessonId: lesson2Id, courseId: courseId, lessonTitle: title, moduleName: "2. Deep Dive", totalDuration: 900.0).navigationBarHidden(true)) {
                                    CourseModuleCard(icon: isL2Completed ? "checkmark.circle.fill" : (isL1Completed ? "play.fill" : "lock.fill"), iconColor: isL2Completed ? .green : (isL1Completed ? .white : .gray), backgroundColor: isL2Completed ? .green.opacity(0.05) : (isL1Completed ? Color.blue.opacity(0.08) : .gray.opacity(0.05)), borderColor: .gray.opacity(0.1), title: "2. Deep Dive", subtitle: "15 mins", isCompleted: isL2Completed, isCurrent: isL1Completed && !isL2Completed, isLocked: !isL1Completed)
                                }.disabled(!isL1Completed)

                                // Quiz
                                NavigationLink(destination: QuizView(courseId: courseId).navigationBarHidden(true)) {
                                    CourseModuleCard(icon: isQuizCompleted ? "checkmark.circle.fill" : (isL2Completed ? "questionmark.circle.fill" : "lock.fill"), iconColor: isQuizCompleted ? .green : (isL2Completed ? .orange : .gray), backgroundColor: isQuizCompleted ? .green.opacity(0.05) : (isL2Completed ? .orange.opacity(0.05) : .gray.opacity(0.05)), borderColor: isQuizCompleted ? .green.opacity(0.2) : (isL2Completed ? .orange.opacity(0.2) : .gray.opacity(0.1)), title: "3. Module Quiz", subtitle: isQuizCompleted ? "Completed" : "Quiz • 15 mins", isCompleted: isQuizCompleted, isCurrent: isL2Completed && !isQuizCompleted, isLocked: !isL2Completed)
                                }.disabled(!isL2Completed)
                            }
                            .padding(.horizontal, 20)
                        }
                        .padding(.bottom, 150) // Space for bottom button
                    }
                }
            }

            // Fixed Bottom Action Button
            VStack(spacing: 0) {
                Spacer()
                
                VStack(spacing: 14) {
                    NavigationLink(destination: Group {
                        if !isL1Completed {
                            LessonView(lessonId: lesson1Id, courseId: courseId, lessonTitle: title, moduleName: "1. Foundations", totalDuration: 720.0).navigationBarHidden(true)
                        } else if !isL2Completed {
                            LessonView(lessonId: lesson2Id, courseId: courseId, lessonTitle: title, moduleName: "2. Deep Dive", totalDuration: 900.0).navigationBarHidden(true)
                        } else if !isQuizCompleted {
                            QuizView(courseId: courseId).navigationBarHidden(true)
                        } else {
                            CertificateView(courseTitle: title)
                        }
                    }) {
                        HStack(spacing: 12) {
                            Text(isCourseFullyCompleted ? "Claim Certificate" : "Resume Learning")
                                .font(.system(size: 16, weight: .heavy))
                                .foregroundStyle(isCourseFullyCompleted ? .black : .white)

                            Image(systemName: isCourseFullyCompleted ? "star.fill" : "arrow.forward")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(isCourseFullyCompleted ? .black : .white)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(isCourseFullyCompleted ? Color(red: 1, green: 0.84, blue: 0) : Color(red: 0.176, green: 0.357, blue: 0.94))
                        .cornerRadius(20)
                        .shadow(color: isCourseFullyCompleted ? Color(red: 1, green: 0.84, blue: 0).opacity(0.4) : Color(red: 0.176, green: 0.357, blue: 0.94).opacity(0.4), radius: 12, x: 0, y: 6)
                    }

                    HStack(spacing: 6) {
                        Image(systemName: "checkmark.seal.fill")
                            .font(.system(size: 10))
                            .foregroundStyle(.gray.opacity(0.4))
                        Text(isCourseFullyCompleted ? "COURSE FULLY COMPLETED" : "VERIFIED .EDU ACCESS ONLY")
                            .font(.system(size: 9, weight: .bold))
                            .tracking(0.5)
                            .foregroundStyle(.gray.opacity(0.4))
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(.horizontal, 20).padding(.vertical, 20).padding(.bottom, 10)
                .background(LinearGradient(gradient: Gradient(colors: [Color.white.opacity(0.0), Color.white.opacity(0.95), Color.white]), startPoint: .top, endPoint: .bottom))
            }
        }
    }

    private func statItem(icon: String, iconColor: Color, value: String, sub: String) -> some View {
        VStack(spacing: 6) {
            HStack(spacing: 6) {
                Image(systemName: icon).font(.system(size: 12)).foregroundStyle(iconColor)
                Text(value).font(.system(size: 13, weight: .bold)).foregroundStyle(.black.opacity(0.9))
                Text(sub).font(.system(size: 11)).foregroundStyle(.gray.opacity(0.5))
            }
        }.frame(maxWidth: .infinity, alignment: .center)
    }
}

// Components

struct CertificateView: View {
    @Environment(\.dismiss) private var dismiss
    let courseTitle: String
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Certificate of Completion")
                .font(.title.bold())
                .multilineTextAlignment(.center)
            Text("Congratulations on finishing\n\(courseTitle)!")
                .foregroundStyle(.gray)
                .multilineTextAlignment(.center)
            
            Button("Go Back") {
                dismiss()
            }
            .buttonStyle(.borderedProminent)
            .padding(.top, 20)
        }
        .navigationBarHidden(true)
    }
}

struct CourseModuleCard: View {
    let icon: String
    let iconColor: Color
    let backgroundColor: Color
    let borderColor: Color
    let title: String
    let subtitle: String
    let isCompleted: Bool
    let isCurrent: Bool
    let isLocked: Bool

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                if isCurrent {
                    Circle().fill(Color(red: 0.176, green: 0.357, blue: 0.94)).shadow(color: Color(red: 0.176, green: 0.357, blue: 0.94).opacity(0.3), radius: 6, x: 0, y: 3)
                } else if isCompleted {
                    Circle().fill(Color.green.opacity(0.2))
                } else {
                    Circle().fill(Color.gray.opacity(0.1)).opacity(isLocked ? 0.6 : 1)
                }
                Image(systemName: icon).font(.system(size: 14, weight: .semibold)).foregroundStyle(isCurrent ? Color.white : iconColor)
            }.frame(width: 40, height: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title).font(.system(size: 13, weight: .bold)).foregroundStyle(isLocked ? .gray.opacity(0.5) : .black.opacity(0.9))
                Text(subtitle).font(.system(size: 9)).foregroundStyle(isCurrent ? Color(red: 0.176, green: 0.357, blue: 0.94) : .gray.opacity(0.4)).fontWeight(isCurrent ? .bold : .regular).tracking(isCurrent ? 0.3 : 0)
            }
            Spacer()
            
            if isCurrent {
                Image(systemName: "mic.fill").font(.system(size: 12)).foregroundStyle(Color(red: 0.176, green: 0.357, blue: 0.94))
            } else {
                Image(systemName: "ellipsis").font(.system(size: 14)).foregroundStyle(.gray.opacity(0.3))
            }
        }.padding(12).background(backgroundColor).cornerRadius(20).overlay(RoundedRectangle(cornerRadius: 20).stroke(borderColor, lineWidth: isLocked ? 1 : 2)).opacity(isLocked ? 0.6 : 1)
    }
}

struct ObjectiveItem: View {
    let text: String
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Circle().fill(Color(red: 0.176, green: 0.357, blue: 0.94)).frame(width: 8, height: 8).padding(.top, 6)
            Text(text).font(.system(size: 15)).foregroundStyle(.gray.opacity(0.7)).lineSpacing(1.2)
            Spacer()
        }
    }
}

#Preview {
    NavigationStack {
        CourseDetailsView(courseId: "test", title: "Psychology 101", category: "Science", duration: "18h", studentCount: "12k", rating: "4.9", reviewsCount: "2k", instructor: "Dr. Jenkins", instructorDept: "Psychology Dept")
    }
}
