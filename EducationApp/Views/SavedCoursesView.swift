import SwiftUI

struct SavedCoursesView: View {
    @StateObject private var persistenceManager = DataPersistenceManager.shared
<<<<<<< HEAD
    @State private var enrolledCourses: [CourseProgress] = []
    var body: some View {
            ZStack {
                Color(red: 0.97, green: 0.98, blue: 0.99).ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // 헤더
                    HStack {
                        Text("Learning Analytics")
                            .font(.system(size: 28, weight: .bold))
                        Spacer()
                        Image(systemName: "chart.bar.xaxis")
                            .font(.title2)
                            .foregroundStyle(.blue)
                    }
                    .padding(20)
                    
                    ScrollView {
                        VStack(spacing: 20) {
                            HStack(spacing: 20) {
                                AnalyticsItem(value: "\(enrolledCourses.count)", label: "Courses", icon: "book.fill", color: .blue)
                                AnalyticsItem(value: "\(persistenceManager.getCompletedLessonsCount())", label: "Lessons", icon: "play.circle.fill", color: .green)
                                AnalyticsItem(value: "3d", label: "Streak", icon: "flame.fill", color: .orange)
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(20)
                            .shadow(color: Color.black.opacity(0.05), radius: 5)
                            .padding(.horizontal)
                            
                            // 상세 리스트
                            VStack(alignment: .leading, spacing: 15) {
                                Text("Course Progress").font(.headline).padding(.horizontal)
                                
                                ForEach(enrolledCourses) { course in
                                    HStack {
                                        VStack(alignment: .leading) {
                                            Text(course.courseName).font(.subheadline.weight(.semibold))
                                            ProgressView(value: course.completionPercentage, total: 100).tint(.blue)
                                        }
                                        Text("\(Int(course.completionPercentage))%").font(.caption.weight(.bold)).foregroundStyle(.gray)
                                    }
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(16)
                                    .padding(.horizontal)
                                }
                            }
                        }
=======
    @StateObject private var loc = LocalizationManager.shared
    @State private var favoriteCourses: [CourseProgress] = []

    var body: some View {
        ZStack {
            Color(.systemBackground).ignoresSafeArea()

            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(loc.localized("Saved Courses"))
                            .font(.system(size: 28, weight: .bold))
                            .foregroundStyle(Color(.label).opacity(0.9))

                        Text(loc.localized("Your bookmarked learning materials"))
                            .font(.system(size: 13))
                            .foregroundStyle(.gray.opacity(0.6))
                    }

                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)

                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 12) {
                        if favoriteCourses.isEmpty {
                            // Empty State
                            VStack(spacing: 16) {
                                Image(systemName: "bookmark.slash.fill")
                                    .font(.system(size: 48))
                                    .foregroundStyle(Color.gray.opacity(0.3))

                                VStack(spacing: 6) {
                                    Text(loc.localized("No Saved Courses Yet"))
                                        .font(.system(size: 18, weight: .bold))
                                        .foregroundStyle(Color(.label).opacity(0.85))

                                    Text(loc.localized("Bookmark courses to save them for later"))
                                        .font(.system(size: 13))
                                        .foregroundStyle(.gray.opacity(0.6))
                                        .multilineTextAlignment(.center)
                                }

                                NavigationLink(destination: CourseCatalogView().navigationBarHidden(true)) {
                                    HStack {
                                        Image(systemName: "sparkles")
                                            .font(.system(size: 14, weight: .semibold))

                                        Text(loc.localized("Browse Catalog"))
                                            .font(.system(size: 14, weight: .bold))
                                    }
                                    .foregroundStyle(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                                    .background(Color(red: 0.231, green: 0.51, blue: 0.96))
                                    .cornerRadius(12)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding(20)
                            .background(Color.gray.opacity(0.05))
                            .cornerRadius(16)
                        } else {
                            ForEach(favoriteCourses) { courseProgress in
                                if let course = CourseStore.sampleCourses.first(where: { $0.id == courseProgress.courseId }) {
                                    NavigationLink(destination: CourseDetailsView(course: course).navigationBarHidden(true)) {
                                        SavedCourseCard(
                                            courseProgress: courseProgress,
                                            categoryColor: colorForCategory(courseProgress.category),
                                            onRemove: {
                                                persistenceManager.toggleCourseFavorite(courseId: courseProgress.courseId)
                                                loadFavorites()
                                            }
                                        )
                                    }
                                }
                            }
                        }

                        Spacer(minLength: 100)
>>>>>>> main
                    }
                }
            }
            .onAppear { enrolledCourses = persistenceManager.getAllCourseProgress() }
        }
<<<<<<< HEAD
}

struct AnalyticsItem: View {
    let value: String, label: String, icon: String, color: Color
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon).font(.title2).foregroundStyle(color)
            Text(value).font(.title3.weight(.bold))
            Text(label).font(.caption).foregroundStyle(.gray)
        }
        .frame(maxWidth: .infinity)
=======
        .onAppear {
            loadFavorites()
        }
    }

    private func loadFavorites() {
        favoriteCourses = persistenceManager.getFavoriteCourses()
    }
}

struct SavedCourseCard: View {
    let courseProgress: CourseProgress
    let categoryColor: Color
    let onRemove: () -> Void

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 14)
                    .fill(categoryColor.opacity(0.1))

                Image(systemName: "book.circle.fill")
                    .font(.system(size: 28))
                    .foregroundStyle(categoryColor.opacity(0.4))
            }
            .frame(width: 60, height: 60)

            VStack(alignment: .leading, spacing: 4) {
                Text(courseProgress.courseName)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundStyle(Color(.label).opacity(0.9))
                    .lineLimit(1)

                HStack(spacing: 8) {
                    Text(courseProgress.category)
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(categoryColor)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(categoryColor.opacity(0.1))
                        .cornerRadius(6)

                    Text("\(Int(courseProgress.completionPercentage))% complete")
                        .font(.system(size: 11))
                        .foregroundStyle(.gray.opacity(0.6))
                }
            }

            Spacer()

            Button(action: onRemove) {
                Image(systemName: "bookmark.fill")
                    .font(.system(size: 16))
                    .foregroundStyle(Color(red: 0.231, green: 0.51, blue: 0.96))
            }
        }
        .padding(14)
        .background(Color.white)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.gray.opacity(0.1), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 2)
>>>>>>> main
    }
}

#Preview {
    SavedCoursesView()
}
