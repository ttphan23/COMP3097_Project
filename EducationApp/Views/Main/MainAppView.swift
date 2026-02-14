import SwiftUI

struct MainAppView: View {
    @State private var selectedTab: Int = 0
    @EnvironmentObject private var appState: AppState

    init() {
        UITabBar.appearance().isHidden = true
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack { HomeStudentDashboardView() }
                .tag(0)

            NavigationStack { CourseCatalogView() }
                .tag(1)

            NavigationStack { AssignmentsView() }
                .tag(2)

            NavigationStack { SavedCoursesView() }
                .tag(3)

            NavigationStack { ProfileView() }
                .tag(4)
        }
        .safeAreaInset(edge: .bottom, spacing: 0) {
            BottomPillBar(selectedTab: $selectedTab)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color.white.opacity(0.001))
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}

struct BottomPillBar: View {
    @Binding var selectedTab: Int

    var body: some View {
        HStack(spacing: 0) {
            pillItem(icon: "house.fill", title: "Home", tab: 0)
            
            pillItem(icon: "square.grid.2x2.fill", title: "Courses", tab: 1)
            
            pillItem(icon: "calendar", title: "Plan", tab: 2)
            
            pillItem(icon: "bookmark.fill", title: "Saved", tab: 3)
            
            pillItem(icon: "person.crop.circle", title: "Me", tab: 4)
        }
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 22)
                .fill(Color.white.opacity(0.95))
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
        )
    }

    @ViewBuilder
    private func pillItem(icon: String, title: String, tab: Int) -> some View {
        let isActive = selectedTab == tab

        Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                selectedTab = tab
            }
        } label: {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .semibold))
                
                if isActive {
                    Text(title)
                        .font(.system(size: 10, weight: .bold))
                        .transition(.scale.combined(with: .opacity))
                        .lineLimit(1)
                }
            }
            .foregroundStyle(isActive ? Color.blue : Color.gray.opacity(0.6))
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(
                isActive
                ? RoundedRectangle(cornerRadius: 18).fill(Color.blue.opacity(0.1))
                : RoundedRectangle(cornerRadius: 18).fill(Color.clear)
            )
        }
    }
}
