import SwiftUI

struct MainAppView: View {
    @State private var selectedTab: Int = 0
    @Binding var isLoggedIn: Bool

    var body: some View {
        ZStack {
            TabView(selection: $selectedTab) {
                // Home Tab
                NavigationStack {
                    HomeStudentDashboardView()
                }
                .tag(0)
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }

                // Catalog Tab
                NavigationStack {
                    CourseCatalogView()
                }
                .tag(1)
                .tabItem {
                    Label("Catalog", systemImage: "sparkles")
                }

                // Bookmarks Tab
                NavigationStack {
                    SavedCoursesView()
                }
                .tag(2)
                .tabItem {
                    Label("Saved", systemImage: "bookmark.fill")
                }

                // Profile Tab
                NavigationStack {
                    ProfileView(isLoggedIn: $isLoggedIn)
                }
                .tag(3)
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle")
                }
            }
            .tint(Color(red: 0.231, green: 0.51, blue: 0.96))
        }
    }
}

#Preview {
    MainAppView(isLoggedIn: .constant(true))
}
