import SwiftUI

struct CourseDetailsView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var studyStore: StudyFeatureStore
    @StateObject private var persistenceManager = DataPersistenceManager.shared

    let course: Course
    @State private var isFavorite: Bool = false
    @State private var completedModuleIds: Set<String> = []

    var completionPercentage: Double {
        guard !course.modules.isEmpty else { return 0 }
        return Double(completedModuleIds.count) / Double(course.modules.count)
    }

    var currentModuleIndex: Int {
        for (index, module) in course.modules.enumerated() {
            if !completedModuleIds.contains(module.id) {
                return index
            }
        }
        return course.modules.count
    }

    var body: some View {
        ZStack {
            Color(.systemBackground).ignoresSafeArea()

            VStack(spacing: 0) {
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

                    Button(action: {
                        if persistenceManager.getCourseProgress(for: course.id) == nil {
                            let progress = CourseProgress(
                                courseId: course.id,
                                courseName: course.title,
                                category: course.category,
                                enrollmentDate: Date(),
                                totalLessons: course.modules.count,
                                isFavorite: true
                            )
                            persistenceManager.saveCourseProgress(progress)
                        } else {
                            persistenceManager.toggleCourseFavorite(courseId: course.id)
                        }
                        isFavorite.toggle()
                    }) {
                        Image(systemName: isFavorite ? "bookmark.fill" : "bookmark")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(
                                isFavorite
                                ? Color(red: 0.231, green: 0.51, blue: 0.96)
                                : .gray.opacity(0.6)
                            )
                            .frame(width: 40, height: 40)
                    }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color(.systemBackground).opacity(0.9))
                .overlay(alignment: .bottom) {
                    Divider()
                }

                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 0) {
                        ZStack(alignment: .bottomLeading) {
                            Image(course.imageName)
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: .infinity)
                                .frame(height: 200)
                                .background(Color.black.opacity(0.06))

                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.black.opacity(0.7),
                                    Color.black.opacity(0.22),
                                    Color.clear
                                ]),
                                startPoint: .bottom,
                                endPoint: .top
                            )
                            .frame(height: 200)

                            VStack(alignment: .leading, spacing: 10) {
                                HStack(spacing: 8) {
                                    Image(systemName: "checkmark.seal.fill")
                                        .font(.system(size: 10))
                                        .foregroundStyle(Color(red: 1, green: 0.84, blue: 0))

                                    Text(".EDU VERIFIED COURSE")
                                        .font(.system(size: 9, weight: .bold))
                                        .tracking(0.8)
                                        .foregroundStyle(.white)
                                }
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color.white.opacity(0.2))
                                .cornerRadius(12)

                                Text(course.title)
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundStyle(.white)
                                    .lineLimit(3)
                            }
                            .padding(18)
                        }
                        .frame(height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 28))
                        .padding(.horizontal, 20)
                        .padding(.top, 16)
                        .padding(.bottom, 12)

                        HStack(spacing: 0) {
                            VStack(spacing: 6) {
                                HStack(spacing: 6) {
                                    Image(systemName: "star.fill")
                                        .font(.system(size: 12))
                                        .foregroundStyle(Color(red: 1, green: 0.84, blue: 0))

                                    Text(String(format: "%.1f", course.rating))
                                        .font(.system(size: 13, weight: .bold))
                                        .foregroundStyle(Color(.label).opacity(0.9))

                                    Text("(\(course.reviewCount) reviews)")
                                        .font(.system(size: 11))
                                        .foregroundStyle(.gray.opacity(0.5))
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)

                            Divider()
                                .frame(height: 16)

                            VStack(spacing: 6) {
                                HStack(spacing: 6) {
                                    Image(systemName: "person.2.fill")
                                        .font(.system(size: 12))
                                        .foregroundStyle(.gray.opacity(0.5))

                                    Text("\(course.studentCount) Students")
                                        .font(.system(size: 13, weight: .semibold))
                                        .foregroundStyle(Color(.label).opacity(0.85))
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .center)

                            Divider()
                                .frame(height: 16)

                            VStack(spacing: 6) {
                                HStack(spacing: 6) {
                                    Image(systemName: "clock.fill")
                                        .font(.system(size: 12))
                                        .foregroundStyle(.gray.opacity(0.5))

                                    Text("\(course.totalHours) Total")
                                        .font(.system(size: 13, weight: .semibold))
                                        .foregroundStyle(Color(.label).opacity(0.85))
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(Color.blue.opacity(0.03))
                        .overlay(
                            VStack {
                                Divider()
                                Spacer()
                                Divider()
                            }
                        )
                        .padding(.bottom, 12)

                        HStack(spacing: 12) {
                            Image(systemName: "person.crop.circle.fill")
                                .font(.system(size: 48))
                                .foregroundStyle(Color.blue.opacity(0.3))
                                .frame(width: 56, height: 56)
                                .background(RoundedRectangle(cornerRadius: 16).fill(Color.gray.opacity(0.1)))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color.white, lineWidth: 4)
                                )
                                .shadow(radius: 4)

                            VStack(alignment: .leading, spacing: 2) {
                                Text("INSTRUCTOR")
                                    .font(.system(size: 9, weight: .bold))
                                    .tracking(0.5)
                                    .foregroundStyle(Color(red: 0.176, green: 0.357, blue: 0.94))

                                Text(course.instructor)
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundStyle(Color(.label).opacity(0.9))

                                Text(course.instructorDepartment)
                                    .font(.system(size: 11))
                                    .foregroundStyle(.gray.opacity(0.55))
                            }

                            Spacer()
                        }
                        .padding(14)
                        .background(Color.gray.opacity(0.03))
                        .cornerRadius(20)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)

                        CoursePrerequisitesSection(course: course)
                            .padding(.horizontal, 20)
                            .padding(.bottom, 24)

                        VStack(alignment: .leading, spacing: 16) {
                            HStack(spacing: 8) {
                                Circle()
                                    .fill(Color(red: 0.176, green: 0.357, blue: 0.94))
                                    .frame(width: 8, height: 8)

                                Text("Key Objectives")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundStyle(Color(.label).opacity(0.9))
                            }

                            VStack(alignment: .leading, spacing: 16) {
                                ForEach(course.objectives, id: \.self) { objective in
                                    ObjectiveItem(text: objective)
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 28)

                        VStack(alignment: .leading, spacing: 16) {
                            HStack(alignment: .top, spacing: 16) {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Course Modules")
                                        .font(.system(size: 18, weight: .bold))
                                        .foregroundStyle(Color(.label).opacity(0.9))

                                    Text("\(course.modules.count) Lessons")
                                        .font(.system(size: 11))
                                        .foregroundStyle(.gray.opacity(0.4))
                                }

                                Spacer()

                                VStack(alignment: .trailing, spacing: 6) {
                                    Text("\(Int(completionPercentage * 100))% Done")
                                        .font(.system(size: 12, weight: .bold))
                                        .foregroundStyle(Color(red: 0.176, green: 0.357, blue: 0.94))

                                    GeometryReader { geo in
                                        ZStack(alignment: .leading) {
                                            RoundedRectangle(cornerRadius: 2)
                                                .fill(Color.gray.opacity(0.1))

                                            RoundedRectangle(cornerRadius: 2)
                                                .fill(Color(red: 0.176, green: 0.357, blue: 0.94))
                                                .frame(width: geo.size.width * completionPercentage)
                                        }
                                    }
                                    .frame(width: 82, height: 6)
                                }
                            }

                            VStack(spacing: 12) {
                                ForEach(Array(course.modules.enumerated()), id: \.element.id) { index, module in
                                    let isCompleted = completedModuleIds.contains(module.id)
                                    let isCurrent = index == currentModuleIndex
                                    let isLocked = index > currentModuleIndex

                                    if !isLocked {
                                        NavigationLink(
                                            destination: LessonView(
                                                lessonId: module.id,
                                                courseId: course.id,
                                                lessonName: module.title,
                                                totalDuration: 24.0
                                            )
                                            .navigationBarHidden(true)
                                        ) {
                                            CourseModuleCard(
                                                icon: moduleIcon(isCompleted: isCompleted, isCurrent: isCurrent, isLocked: isLocked),
                                                iconColor: moduleIconColor(isCompleted: isCompleted, isCurrent: isCurrent, isLocked: isLocked),
                                                backgroundColor: moduleBackgroundColor(isCompleted: isCompleted, isCurrent: isCurrent, isLocked: isLocked),
                                                borderColor: moduleBorderColor(isCompleted: isCompleted, isCurrent: isCurrent, isLocked: isLocked),
                                                title: module.title,
                                                subtitle: moduleSubtitle(module: module, isCompleted: isCompleted, isCurrent: isCurrent),
                                                isCompleted: isCompleted,
                                                isCurrent: isCurrent,
                                                isLocked: isLocked
                                            )
                                        }
                                    } else {
                                        CourseModuleCard(
                                            icon: moduleIcon(isCompleted: isCompleted, isCurrent: isCurrent, isLocked: isLocked),
                                            iconColor: moduleIconColor(isCompleted: isCompleted, isCurrent: isCurrent, isLocked: isLocked),
                                            backgroundColor: moduleBackgroundColor(isCompleted: isCompleted, isCurrent: isCurrent, isLocked: isLocked),
                                            borderColor: moduleBorderColor(isCompleted: isCompleted, isCurrent: isCurrent, isLocked: isLocked),
                                            title: module.title,
                                            subtitle: moduleSubtitle(module: module, isCompleted: isCompleted, isCurrent: isCurrent),
                                            isCompleted: isCompleted,
                                            isCurrent: isCurrent,
                                            isLocked: isLocked
                                        )
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 20)

                        if !completedModuleIds.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                HStack(spacing: 8) {
                                    Circle()
                                        .fill(Color.purple)
                                        .frame(width: 8, height: 8)

                                    Text("Course Quiz")
                                        .font(.system(size: 18, weight: .bold))
                                        .foregroundStyle(Color(.label).opacity(0.9))
                                }

                                NavigationLink(
                                    destination: QuizView(
                                        courseName: course.title,
                                        questions: CourseQuizStore.questions(for: course.id)
                                    )
                                ) {
                                    HStack(spacing: 12) {
                                        Image(systemName: "questionmark.circle.fill")
                                            .font(.system(size: 22))
                                            .foregroundStyle(.purple)

                                        VStack(alignment: .leading, spacing: 2) {
                                            Text("Test Your Knowledge")
                                                .font(.system(size: 14, weight: .bold))
                                                .foregroundStyle(Color(.label).opacity(0.85))

                                            Text("\(CourseQuizStore.questions(for: course.id).count) questions")
                                                .font(.system(size: 11))
                                                .foregroundStyle(.gray.opacity(0.5))
                                        }

                                        Spacer()

                                        Image(systemName: "chevron.right")
                                            .font(.system(size: 14, weight: .semibold))
                                            .foregroundStyle(.gray.opacity(0.4))
                                    }
                                    .padding(14)
                                    .background(Color.purple.opacity(0.06))
                                    .cornerRadius(16)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(Color.purple.opacity(0.15), lineWidth: 1)
                                    )
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 20)
                        }

                        CourseReviewsEntrySection(
                            course: course,
                            courseCompleted: currentModuleIndex >= course.modules.count
                        )
                        .padding(.horizontal, 20)
                        .padding(.top, 20)

                        Spacer(minLength: 140)
                    }
                }
            }

            VStack(spacing: 0) {
                Spacer()

                VStack(spacing: 14) {
                    if currentModuleIndex < course.modules.count {
                        let currentModule = course.modules[currentModuleIndex]

                        NavigationLink(
                            destination: LessonView(
                                lessonId: currentModule.id,
                                courseId: course.id,
                                lessonName: currentModule.title,
                                totalDuration: 24.0
                            )
                            .navigationBarHidden(true)
                        ) {
                            HStack(spacing: 12) {
                                Text(completedModuleIds.isEmpty ? "Start Learning" : "Resume Learning")
                                    .font(.system(size: 16, weight: .heavy))
                                    .foregroundStyle(.white)

                                Image(systemName: "arrow.forward")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundStyle(.white)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(Color(red: 0.176, green: 0.357, blue: 0.94))
                            .cornerRadius(20)
                            .shadow(
                                color: Color(red: 0.176, green: 0.357, blue: 0.94).opacity(0.4),
                                radius: 12,
                                x: 0,
                                y: 6
                            )
                        }
                    } else {
                        VStack(spacing: 10) {
                            HStack(spacing: 12) {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.system(size: 20))

                                Text("Course Completed!")
                                    .font(.system(size: 16, weight: .heavy))
                            }
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(Color.green)
                            .cornerRadius(20)

                            NavigationLink(
                                destination: QuizView(
                                    courseName: course.title,
                                    questions: CourseQuizStore.questions(for: course.id)
                                )
                            ) {
                                HStack(spacing: 8) {
                                    Image(systemName: "questionmark.circle.fill")
                                        .font(.system(size: 16))
                                    Text("Take Quiz")
                                        .font(.system(size: 14, weight: .bold))
                                }
                                .foregroundStyle(Color(red: 0.176, green: 0.357, blue: 0.94))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(16)
                            }

                            NavigationLink(destination: CourseReviewsView(course: course)) {
                                HStack(spacing: 8) {
                                    Image(systemName: "text.bubble.fill")
                                        .font(.system(size: 16))
                                    Text("Write Course Review")
                                        .font(.system(size: 14, weight: .bold))
                                }
                                .foregroundStyle(.green)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(Color.green.opacity(0.1))
                                .cornerRadius(16)
                            }
                        }
                    }

                    HStack(spacing: 6) {
                        Image(systemName: "checkmark.seal.fill")
                            .font(.system(size: 10))
                            .foregroundStyle(.gray.opacity(0.4))

                        Text("VERIFIED .EDU ACCESS ONLY")
                            .font(.system(size: 9, weight: .bold))
                            .tracking(0.5)
                            .foregroundStyle(.gray.opacity(0.4))
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 20)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(.systemBackground).opacity(0.9),
                            Color(.systemBackground).opacity(0.95),
                            Color(.systemBackground)
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .overlay(alignment: .top) {
                    Divider()
                }
            }
        }
        .onAppear {
            isFavorite = persistenceManager.isCourseFavorite(courseId: course.id)
            let completed = persistenceManager.getCompletedModuleIds(for: course.id)
            completedModuleIds = Set(completed)
        }
    }

    private func moduleIcon(isCompleted: Bool, isCurrent: Bool, isLocked: Bool) -> String {
        if isCompleted { return "checkmark.circle.fill" }
        if isCurrent { return "play.fill" }
        if isLocked { return "lock.fill" }
        return "book.fill"
    }

    private func moduleIconColor(isCompleted: Bool, isCurrent: Bool, isLocked: Bool) -> Color {
        if isCompleted { return .green }
        if isCurrent { return .white }
        if isLocked { return .gray.opacity(0.3) }
        return Color(red: 0.176, green: 0.357, blue: 0.94)
    }

    private func moduleBackgroundColor(isCompleted: Bool, isCurrent: Bool, isLocked: Bool) -> Color {
        if isCompleted { return Color.green.opacity(0.06) }
        if isCurrent { return Color(red: 0.176, green: 0.357, blue: 0.94).opacity(0.08) }
        if isLocked { return Color.gray.opacity(0.03) }
        return Color.blue.opacity(0.03)
    }

    private func moduleBorderColor(isCompleted: Bool, isCurrent: Bool, isLocked: Bool) -> Color {
        if isCompleted { return Color.green.opacity(0.2) }
        if isCurrent { return Color(red: 0.176, green: 0.357, blue: 0.94).opacity(0.2) }
        if isLocked { return Color.gray.opacity(0.1) }
        return Color.blue.opacity(0.15)
    }

    private func moduleSubtitle(module: CourseModule, isCompleted: Bool, isCurrent: Bool) -> String {
        if isCompleted { return "Completed" }
        if isCurrent { return "Current Module" }
        return module.duration
    }
}

struct CoursePrerequisitesSection: View {
    let course: Course
    @EnvironmentObject private var studyStore: StudyFeatureStore

    private var prerequisites: [Course] {
        studyStore.prerequisiteCourses(for: course.id)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 8) {
                Circle()
                    .fill(Color.orange)
                    .frame(width: 8, height: 8)

                Text("Prerequisites")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(Color(.label).opacity(0.9))
            }

            if prerequisites.isEmpty {
                Text("No prerequisite courses are required before starting this course.")
                    .font(.system(size: 14))
                    .foregroundStyle(.gray.opacity(0.7))
                    .padding(14)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.orange.opacity(0.06))
                    .cornerRadius(16)
            } else {
                VStack(spacing: 10) {
                    ForEach(prerequisites) { prerequisite in
                        HStack(spacing: 12) {
                            Image(systemName: "checkmark.seal.fill")
                                .font(.system(size: 18))
                                .foregroundStyle(.orange)

                            VStack(alignment: .leading, spacing: 4) {
                                Text(prerequisite.title)
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundStyle(Color(.label).opacity(0.88))

                                Text("\(prerequisite.category) • \(prerequisite.totalHours)")
                                    .font(.system(size: 11))
                                    .foregroundStyle(.gray.opacity(0.6))
                            }

                            Spacer()
                        }
                        .padding(14)
                        .background(Color.orange.opacity(0.06))
                        .cornerRadius(16)
                    }
                }
            }
        }
    }
}

struct CourseReviewsEntrySection: View {
    let course: Course
    let courseCompleted: Bool
    @EnvironmentObject private var studyStore: StudyFeatureStore

    private var reviewCount: Int {
        studyStore.reviews(for: course.id).count
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Circle()
                    .fill(Color.green)
                    .frame(width: 8, height: 8)

                Text("Course Reviews")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(Color(.label).opacity(0.9))
            }

            NavigationLink(destination: CourseReviewsView(course: course)) {
                HStack(spacing: 12) {
                    Image(systemName: "text.bubble.fill")
                        .font(.system(size: 22))
                        .foregroundStyle(.green)

                    VStack(alignment: .leading, spacing: 3) {
                        Text(courseCompleted ? "Write or Read Reviews" : "Read Reviews")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(Color(.label).opacity(0.88))

                        Text("\(reviewCount) saved review\(reviewCount == 1 ? "" : "s")")
                            .font(.system(size: 11))
                            .foregroundStyle(.gray.opacity(0.55))
                    }

                    Spacer()

                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.gray.opacity(0.4))
                }
                .padding(14)
                .background(Color.green.opacity(0.06))
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.green.opacity(0.15), lineWidth: 1)
                )
            }
        }
    }
}

struct ObjectiveItem: View {
    let text: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Circle()
                .fill(Color(red: 0.176, green: 0.357, blue: 0.94))
                .frame(width: 8, height: 8)
                .padding(.top, 6)

            Text(text)
                .font(.system(size: 15))
                .foregroundStyle(.gray.opacity(0.7))
                .lineSpacing(1.2)

            Spacer()
        }
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
                    Circle()
                        .fill(Color(red: 0.176, green: 0.357, blue: 0.94))
                        .shadow(
                            color: Color(red: 0.176, green: 0.357, blue: 0.94).opacity(0.3),
                            radius: 6,
                            x: 0,
                            y: 3
                        )
                } else if isCompleted {
                    Circle()
                        .fill(Color.green.opacity(0.2))
                } else {
                    Circle()
                        .fill(Color.gray.opacity(0.1))
                        .opacity(isLocked ? 0.6 : 1)
                }

                Image(systemName: icon)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(isCurrent ? Color.white : iconColor)
            }
            .frame(width: 40, height: 40)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 13, weight: .bold))
                    .foregroundStyle(isLocked ? .gray.opacity(0.5) : Color(.label).opacity(0.9))

                Text(subtitle)
                    .font(.system(size: 9))
                    .foregroundStyle(
                        isCurrent
                        ? Color(red: 0.176, green: 0.357, blue: 0.94)
                        : .gray.opacity(0.4)
                    )
                    .fontWeight(isCurrent ? .bold : .regular)
                    .tracking(isCurrent ? 0.3 : 0)
            }

            Spacer()

            if isCurrent {
                Image(systemName: "mic.fill")
                    .font(.system(size: 12))
                    .foregroundStyle(Color(red: 0.176, green: 0.357, blue: 0.94))
            } else if isCompleted {
                Image(systemName: "checkmark")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(.green)
            } else if isLocked {
                Image(systemName: "lock.fill")
                    .font(.system(size: 12))
                    .foregroundStyle(.gray.opacity(0.3))
            } else {
                Image(systemName: "ellipsis")
                    .font(.system(size: 14))
                    .foregroundStyle(.gray.opacity(0.3))
            }
        }
        .padding(12)
        .background(backgroundColor)
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(borderColor, lineWidth: isLocked ? 1 : 2)
        )
        .opacity(isLocked ? 0.6 : 1)
    }
}

#Preview {
    NavigationStack {
        CourseDetailsView(course: CourseStore.sampleCourses[0])
            .environmentObject(StudyFeatureStore.shared)
    }
}
