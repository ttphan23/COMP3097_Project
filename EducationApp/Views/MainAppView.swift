import SwiftUI

struct MainAppView: View {
    @State private var selectedTab: Int = 0
    @Binding var isLoggedIn: Bool

    init(isLoggedIn: Binding<Bool>) {
        self._isLoggedIn = isLoggedIn
        UITabBar.appearance().isHidden = true
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack { HomeStudentDashboardView() }
                .tag(0)

            NavigationStack { CourseCatalogView() }
                .tag(1)

            NavigationStack { SavedCoursesView() }
                .tag(2)

            NavigationStack { ProfileView(isLoggedIn: $isLoggedIn) }
                .tag(3)
        }
        .toolbar(.hidden, for: .tabBar)
        .toolbarBackground(.hidden, for: .tabBar)
        .safeAreaInset(edge: .bottom, spacing: 0) {
            BottomPillBar(selectedTab: $selectedTab)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color.white.opacity(0.001))
        }
    }
}

struct BottomPillBar: View {
    @Binding var selectedTab: Int

    var body: some View {
        HStack(spacing: 0) {
            pillItem(icon: "house.fill", title: "Home", tab: 0)
            pillItem(icon: "sparkles", title: "Catalog", tab: 1)
            pillItem(icon: "bookmark.fill", title: "Saved", tab: 2)
            pillItem(icon: "person.crop.circle", title: "Profile", tab: 3)
        }
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 22)
                .fill(Color.white.opacity(0.95))
                .shadow(radius: 10)
        )
    }

    @ViewBuilder
    private func pillItem(icon: String, title: String, tab: Int) -> some View {
        let isActive = selectedTab == tab

        Button {
            selectedTab = tab
        } label: {
            VStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .semibold))
                Text(title)
                    .font(.system(size: 10, weight: .bold))
            }
            .foregroundStyle(isActive ? Color.blue : Color.gray.opacity(0.6))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(
                isActive
                ? RoundedRectangle(cornerRadius: 18).fill(Color.gray.opacity(0.12))
                : RoundedRectangle(cornerRadius: 18).fill(Color.clear)
            )
        }
    }
}
