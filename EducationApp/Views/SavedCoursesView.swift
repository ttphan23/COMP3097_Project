import SwiftUI

struct SavedCoursesView: View {
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

                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
        }
    }
}

#Preview {
    SavedCoursesView()
}
