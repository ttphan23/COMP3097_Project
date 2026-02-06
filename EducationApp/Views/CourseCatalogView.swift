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
                                    action: {
                                        selectedCategory = category
                                    }
                                )
                            }
                        }
                        .padding(.horizontal, 2)
                    }
                }
                .padding(16)
                .background(Color.white)
                .overlay(alignment: .bottom) {
                    Divider()
                }

                // Course List
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 16) {
                        NavigationLink(destination: CourseDetailsView().navigationBarHidden(true)) {
                            CourseCard(
                                courseId: "course_quantum_physics_101",
                                title: "Quantum Physics 101",
                                category: "Science",
                                categoryColor: Color.blue,
                                duration: "12 Weeks",
                                difficulty: "Hard",
                                difficultyColor: Color.red,
                                studentCount: "12k",
                                isEnrolled: enrolledCourses.contains("course_quantum_physics_101"),
                                onEnroll: { courseId in
                                    let progress = CourseProgress(
                                        courseId: courseId,
                                        courseName: "Quantum Physics 101",
                                        category: "Science",
                                        enrollmentDate: Date(),
                                        totalLessons: 12
                                    )
                                    persistenceManager.saveCourseProgress(progress)
                                    enrolledCourses.insert(courseId)
                                }
                            )
                        }

                        NavigationLink(destination: CourseDetailsView().navigationBarHidden(true)) {
                            CourseCard(
                                courseId: "course_modern_art_history",
                                title: "Modern Art History",
                                category: "Arts",
                                categoryColor: Color.orange,
                                duration: "6 Weeks",
                                difficulty: "Easy",
                                difficultyColor: Color.green,
                                studentCount: "5k",
                                isEnrolled: enrolledCourses.contains("course_modern_art_history"),
                                onEnroll: { courseId in
                                    let progress = CourseProgress(
                                        courseId: courseId,
                                        courseName: "Modern Art History",
                                        category: "Arts",
                                        enrollmentDate: Date(),
                                        totalLessons: 8
                                    )
                                    persistenceManager.saveCourseProgress(progress)
                                    enrolledCourses.insert(courseId)
                                }
                            )
                        }

                        NavigationLink(destination: CourseDetailsView().navigationBarHidden(true)) {
                            CourseCard(
                                courseId: "course_algorithm_design",
                                title: "Algorithm Design",
                                category: "Engineering",
                                categoryColor: Color(red: 0.196, green: 0.784, blue: 0.471),
                                duration: "10 Weeks",
                                difficulty: "Medium",
                                difficultyColor: Color.amber,
                                studentCount: "8k",
                                isEnrolled: enrolledCourses.contains("course_algorithm_design"),
                                onEnroll: { courseId in
                                    let progress = CourseProgress(
                                        courseId: courseId,
                                        courseName: "Algorithm Design",
                                        category: "Engineering",
                                        enrollmentDate: Date(),
                                        totalLessons: 10
                                    )
                                    persistenceManager.saveCourseProgress(progress)
                                    enrolledCourses.insert(courseId)
                                }
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

            // Bottom Navigation
            VStack(spacing: 0) {
                Spacer()

                Divider()

                HStack(spacing: 0) {
                    NavigationTab(icon: "sparkles", label: "Catalog", isActive: true)
                    NavigationTab(icon: "book.fill", label: "Courses", isActive: false)
                    NavigationTab(icon: "bookmark.fill", label: "Saved", isActive: false)
                    NavigationTab(icon: "person.crop.circle", label: "Profile", isActive: false)
                }
                .frame(height: 70)
                .background(Color.white.opacity(0.9))
            }
        }
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
            return Color.amber
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
    CourseCatalogView()
}
