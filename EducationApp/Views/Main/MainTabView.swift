import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            HomeStudentDashboardView()
                .tabItem { Label("Home", systemImage: "house.fill") }

            CourseCatalogView()
                .tabItem { Label("Courses", systemImage: "books.vertical.fill") }

            AssignmentsView()
                .tabItem { Label("Tasks", systemImage: "checklist") }

            ProfileView()
                .tabItem { Label("Profile", systemImage: "person.crop.circle") }
        }
    }
}

#Preview {
    MainTabView()
}
