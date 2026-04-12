import SwiftUI

struct CourseCatalogView: View {
    @State private var searchText: String = ""
    @State private var selectedCategory: String = "All"
    @StateObject private var persistenceManager = DataPersistenceManager.shared
    @State private var enrolledCourses: Set<String> = []

    let categories = ["All", "Science", "Arts", "Engineering", "Business"]

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            VStack(spacing: 0) {
                // Header
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Course Catalog")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundStyle(.black.opacity(0.9))

                            HStack(spacing: 6) {
                                Image(systemName: "checkmark.seal.fill")
                                    .font(.system(size: 12))
                                    .foregroundStyle(Color(red: 0.231, green: 0.51, blue: 0.96))

                                Text(".EDU EXCLUSIVE ACCESS")
                                    .font(.system(size: 10, weight: .bold))
                                    .tracking(0.4)
                                    .foregroundStyle(.gray.opacity(0.5))
                            }
                        }
                        Spacer()
                        Button(action: {}) {
                            ZStack(alignment: .topTrailing) {
                                Image(systemName: "bell.fill")
                                    .font(.system(size: 16))
                                    .foregroundStyle(.gray.opacity(0.6))
                                    .frame(width: 44, height: 44)
                                    .background(RoundedRectangle(cornerRadius: 12).fill(Color.gray.opacity(0.08)))

                                Circle()
                                    .fill(Color.red)
                                    .frame(width: 10, height: 10)
                                    .padding(4)
                            }
                        }
                    }

                    // Search Bar
                    HStack(spacing: 12) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 16))
                            .foregroundStyle(Color(red: 0.231, green: 0.51, blue: 0.96))

                        TextField("What do you want to learn today?", text: $searchText)
                            .font(.system(size: 15))
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled(true)
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 12)
                    .background(RoundedRectangle(cornerRadius: 16).fill(Color.gray.opacity(0.08)))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.gray.opacity(0.15), lineWidth: 2)
                    )

                    // Category Filters
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(categories, id: \.self) { category in
                                CategoryButton(
                                    title: category,
                                    isSelected: selectedCategory == category,
                                    action: { selectedCategory = category }
                                )
                            }
                        }
                        .padding(.horizontal, 2)
                    }
                }
                .padding(16)
                .background(Color.white)
                .overlay(alignment: .bottom) { Divider() }

                // Course List
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 16) {

                        NavigationLink(destination: CourseDetailsView(
                            courseId: "course_quantum_physics_101",
                            title: "Quantum Physics 101",
                            category: "Science",
                            duration: "12 Weeks",
                            studentCount: "12k",
                            rating: "4.9",
                            reviewsCount: "2k",
                            instructor: "Dr. Richard Feynman",
                            instructorDept: "Dept. of Physics"
                        ).navigationBarHidden(true)) {
                            CourseCard(
                                courseId: "course_quantum_physics_101", title: "Quantum Physics 101", category: "Science", categoryColor: Color.blue, duration: "12 Weeks", difficulty: "Hard", difficultyColor: Color.red, studentCount: "12k", isEnrolled: enrolledCourses.contains("course_quantum_physics_101"),
                                onEnroll: { enroll(courseId: $0, name: "Quantum Physics 101", category: "Science", lessons: 12) }
                            )
                        }


                        NavigationLink(destination: CourseDetailsView(
                            courseId: "course_modern_art_history",
                            title: "Modern Art History",
                            category: "Arts",
                            duration: "6 Weeks",
                            studentCount: "5k",
                            rating: "4.8",
                            reviewsCount: "1.5k",
                            instructor: "Prof. Clara Hughes",
                            instructorDept: "Dept. of Fine Arts"
                        ).navigationBarHidden(true)) {
                            CourseCard(
                                courseId: "course_modern_art_history", title: "Modern Art History", category: "Arts", categoryColor: Color.orange, duration: "6 Weeks", difficulty: "Easy", difficultyColor: Color.green, studentCount: "5k", isEnrolled: enrolledCourses.contains("course_modern_art_history"),
                                onEnroll: { enroll(courseId: $0, name: "Modern Art History", category: "Arts", lessons: 8) }
                            )
                        }

                        NavigationLink(destination: CourseDetailsView(
                            courseId: "course_algorithm_design",
                            title: "Algorithm Design",
                            category: "Engineering",
                            duration: "10 Weeks",
                            studentCount: "8k",
                            rating: "4.7",
                            reviewsCount: "3k",
                            instructor: "Dr. Alan Turing",
                            instructorDept: "Dept. of Computer Science"
                        ).navigationBarHidden(true)) {
                            CourseCard(
                                courseId: "course_algorithm_design", title: "Algorithm Design", category: "Engineering", categoryColor: Color(red: 0.196, green: 0.784, blue: 0.471), duration: "10 Weeks", difficulty: "Medium", difficultyColor: Color.orange, studentCount: "8k", isEnrolled: enrolledCourses.contains("course_algorithm_design"),
                                onEnroll: { enroll(courseId: $0, name: "Algorithm Design", category: "Engineering", lessons: 10) }
                            )
                        }

                        Spacer(minLength: 60)
                    }
                    .padding(16)
                }
                .onAppear {
                    let enrolled = persistenceManager.getAllCourseProgress().map { $0.courseId }
                    enrolledCourses = Set(enrolled)
                }
            }
        }
    }
    
    private func enroll(courseId: String, name: String, category: String, lessons: Int) {
        let progress = CourseProgress(courseId: courseId, courseName: name, category: category, enrollmentDate: Date(), totalLessons: lessons)
        persistenceManager.saveCourseProgress(progress)
        enrolledCourses.insert(courseId)
    }
}

struct CategoryButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var categoryColor: Color {
        switch title {
        case "Science":
            return Color.blue
        case "Arts":
            return Color.purple
        case "Engineering":
            return Color(red: 0.196, green: 0.784, blue: 0.471)
        case "Business":
            return Color.orange
        default:
            return Color.blue
        }
    }

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(isSelected ? .white : categoryColor)
                .frame(minWidth: 70)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(
                    isSelected
                        ? RoundedRectangle(cornerRadius: 12).fill(Color(red: 0.231, green: 0.51, blue: 0.96))
                        : RoundedRectangle(cornerRadius: 12).fill(categoryColor.opacity(0.1))
                )
                .overlay(
                    !isSelected ? AnyView(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(categoryColor.opacity(0.2), lineWidth: 1)
                    ) : AnyView(EmptyView())
                )
                .shadow(color: isSelected ? Color(red: 0.231, green: 0.51, blue: 0.96).opacity(0.25) : Color.clear, radius: 6, x: 0, y: 2)
        }
    }
}

struct CourseCard: View {
    let courseId: String
    let title: String
    let category: String
    let categoryColor: Color
    let duration: String
    let difficulty: String
    let difficultyColor: Color
    let studentCount: String
    let isEnrolled: Bool
    let onEnroll: (String) -> Void

    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color.gray.opacity(0.1))

                Image(systemName: "book.circle.fill")
                    .font(.system(size: 100))
                    .foregroundStyle(categoryColor.opacity(0.2))
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                    .offset(x: 20, y: 20)

                LinearGradient(
                    gradient: Gradient(colors: [Color.black.opacity(0.2), Color.clear]),
                    startPoint: .bottom,
                    endPoint: .top
                )

                HStack(spacing: 6) {
                    Circle()
                        .fill(categoryColor)
                        .frame(width: 6, height: 6)

                    Text(category.uppercased())
                        .font(.system(size: 10, weight: .bold))
                        .tracking(0.3)
                        .foregroundStyle(categoryColor)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(Color.white.opacity(0.9))
                .cornerRadius(12)
                .padding(12)
            }
            .frame(height: 176)

            VStack(alignment: .leading, spacing: 12) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(title)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(.black.opacity(0.9))
                        .lineLimit(2)

                    HStack(spacing: 16) {
                        HStack(spacing: 6) {
                            Image(systemName: "clock.fill")
                                .font(.system(size: 14))
                                .foregroundStyle(Color(red: 0.231, green: 0.51, blue: 0.96))

                            Text(duration)
                                .font(.system(size: 13, weight: .medium))
                                .foregroundStyle(.gray.opacity(0.65))
                        }

                        HStack(spacing: 6) {
                            Image(systemName: "bolt.fill")
                                .font(.system(size: 14))
                                .foregroundStyle(difficultyColor)

                            Text(difficulty)
                                .font(.system(size: 13, weight: .medium))
                                .foregroundStyle(.gray.opacity(0.65))
                        }
                    }
                }

                HStack(spacing: 12) {
                    // Student Avatars
                    HStack(spacing: -8) {
                        Circle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 32, height: 32)
                            .overlay(
                                Circle()
                                    .stroke(Color.white, lineWidth: 2)
                            )

                        VStack {
                            Text("+\(studentCount)")
                                .font(.system(size: 9, weight: .bold))
                                .foregroundStyle(.gray.opacity(0.7))
                        }
                        .frame(width: 32, height: 32)
                        .background(Color.gray.opacity(0.15))
                        .cornerRadius(16)
                        .overlay(
                            Circle()
                                .stroke(Color.white, lineWidth: 2)
                        )
                    }

                    Spacer()

                    Button(action: {
                        if !isEnrolled {
                            onEnroll(courseId)
                        }
                    }) {
                        Text(isEnrolled ? "Enrolled" : "Enroll Now")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundStyle(isEnrolled ? .black.opacity(0.9) : .white)
                            .frame(minWidth: 100)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 16)
                            .background(
                                isEnrolled
                                    ? RoundedRectangle(cornerRadius: 16).fill(Color.gray.opacity(0.1))
                                    : RoundedRectangle(cornerRadius: 16).fill(Color(red: 0.231, green: 0.51, blue: 0.96))
                            )
                            .shadow(color: isEnrolled ? Color.clear : Color(red: 0.231, green: 0.51, blue: 0.96).opacity(0.2), radius: 8, x: 0, y: 2)
                    }
                    .disabled(isEnrolled)
                }
            }
            .padding(16)
        }
        .background(Color.white)
        .cornerRadius(24)
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(Color.gray.opacity(0.1), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
        .scaleEffect(0.98, anchor: .center)
    }
}

struct NavigationTab: View {
    let icon: String
    let label: String
    let isActive: Bool

    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .semibold))

            Text(label)
                .font(.system(size: 9, weight: .bold))
                .tracking(0.3)
        }
        .foregroundStyle(isActive ? Color(red: 0.231, green: 0.51, blue: 0.96) : .gray.opacity(0.4))
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    NavigationStack {
        CourseCatalogView()
    }
}
