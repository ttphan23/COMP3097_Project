import SwiftUI

struct SavedCoursesView: View {
    @StateObject private var persistenceManager = DataPersistenceManager.shared
    @State private var favoriteCourses: [CourseProgress] = []

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Saved Courses")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundStyle(.black.opacity(0.9))

                        Text("Your bookmarked learning materials")
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
                                    Text("No Saved Courses Yet")
                                        .font(.system(size: 18, weight: .bold))
                                        .foregroundStyle(.black.opacity(0.85))

                                    Text("Bookmark courses to save them for later")
                                        .font(.system(size: 13))
                                        .foregroundStyle(.gray.opacity(0.6))
                                        .multilineTextAlignment(.center)
                                }

                                NavigationLink(destination: CourseCatalogView().navigationBarHidden(true)) {
                                    HStack {
                                        Image(systemName: "sparkles")
                                            .font(.system(size: 14, weight: .semibold))

                                        Text("Browse Catalog")
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
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
        }
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
                    .foregroundStyle(.black.opacity(0.9))
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
    }
}

#Preview {
    SavedCoursesView()
}
