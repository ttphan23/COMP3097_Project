import SwiftUI

struct ProfileView: View {
    @EnvironmentObject private var appState: AppState
    @EnvironmentObject private var userStore: UserStore

    @StateObject private var persistenceManager = DataPersistenceManager.shared

    @State private var showLogoutAlert: Bool = false
    @State private var notificationsEnabled: Bool = true
    @State private var darkModeEnabled: Bool = false
    @State private var language: String = "English"

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 20) {
                    // Profile Header
                    VStack(spacing: 16) {
                        Image(systemName: "person.crop.circle.fill")
                            .font(.system(size: 80))
                            .foregroundStyle(Color(red: 0.231, green: 0.51, blue: 0.96).opacity(0.2))
                            .frame(width: 100, height: 100)
                            .background(
                                Circle()
                                    .fill(Color(red: 0.231, green: 0.51, blue: 0.96).opacity(0.1))
                                    .overlay(
                                        Circle()
                                            .stroke(Color(red: 0.231, green: 0.51, blue: 0.96).opacity(0.2), lineWidth: 2)
                                    )
                            )

                        VStack(spacing: 4) {
                            Text("Alex Smith")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundStyle(.black.opacity(0.9))

                            Text("alex.smith@stanford.edu")
                                .font(.system(size: 13))
                                .foregroundStyle(.gray.opacity(0.6))
                        }

                        HStack(spacing: 8) {
                            Image(systemName: "checkmark.seal.fill")
                                .font(.system(size: 12))
                                .foregroundStyle(Color.green)

                            Text("Stanford University Verified")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundStyle(Color.green)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color.green.opacity(0.1))
                        .cornerRadius(8)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(20)
                    .background(Color.gray.opacity(0.05))
                    .cornerRadius(16)

                    // Stats
                    VStack(spacing: 12) {
                        Text("Learning Stats")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(.black.opacity(0.9))
                            .frame(maxWidth: .infinity, alignment: .leading)

                        HStack(spacing: 12) {
                            StatCard(
                                icon: "book.fill",
                                iconColor: Color.blue,
                                title: "Courses Enrolled",
                                value: "8"
                            )

                            StatCard(
                                icon: "checkmark.circle.fill",
                                iconColor: Color.green,
                                title: "Completed",
                                value: "3"
                            )

                            StatCard(
                                icon: "flame.fill",
                                iconColor: Color.orange,
                                title: "Streak",
                                value: "12d"
                            )
                        }
                        NavigationLink(destination: SavedCoursesView()) {
                            HStack {
                                Text("View Detailed Analytics")
                                    .font(.system(size: 14, weight: .semibold))
                                Image(systemName: "arrow.right")
                                    .font(.system(size: 12))
                            }
                            .foregroundStyle(Color.blue)
                            .padding(.vertical, 8)
                            .frame(maxWidth: .infinity)
                            .background(Color.blue.opacity(0.05))
                            .cornerRadius(10)
                        }
                    }
                    .padding(16)
                    .background(Color.white)
                    .cornerRadius(16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.gray.opacity(0.1), lineWidth: 1)
                    )

                    // Settings Section
                    VStack(spacing: 0) {
                        Text("Settings")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(.black.opacity(0.9))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.bottom, 12)

                        // Notifications Toggle
                        HStack(spacing: 12) {
                            Image(systemName: "bell.fill")
                                .font(.system(size: 14))
                                .foregroundStyle(Color(red: 0.231, green: 0.51, blue: 0.96))
                                .frame(width: 24, alignment: .center)

                            Text("Notifications")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(.black.opacity(0.85))

                            Spacer()

                            Toggle("", isOn: $notificationsEnabled)
                                .onChange(of: notificationsEnabled) {
                                    persistenceManager.updateNotificationPreference(notificationsEnabled)
                                }
                        }

                        Divider()
                            .padding(.vertical, 8)

                        // Dark Mode Toggle
                        HStack(spacing: 12) {
                            Image(systemName: "moon.fill")
                                .font(.system(size: 14))
                                .foregroundStyle(Color(red: 0.231, green: 0.51, blue: 0.96))
                                .frame(width: 24, alignment: .center)

                            Text("Dark Mode")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(.black.opacity(0.85))

                            Spacer()

                            Toggle("", isOn: $darkModeEnabled)
                                .onChange(of: darkModeEnabled) {
                                    persistenceManager.updateDarkModePreference(darkModeEnabled)
                                }
                        }

                        Divider()
                            .padding(.vertical, 8)

                        // Language Picker
                        HStack(spacing: 12) {
                            Image(systemName: "globe")
                                .font(.system(size: 14))
                                .foregroundStyle(Color(red: 0.231, green: 0.51, blue: 0.96))
                                .frame(width: 24, alignment: .center)

                            Text("Language")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(.black.opacity(0.85))

                            Spacer()

                            Picker("", selection: $language) {
                                Text("English").tag("English")
                                Text("Spanish").tag("Spanish")
                                Text("French").tag("French")
                                Text("German").tag("German")
                            }
                            .onChange(of: language) {
                                persistenceManager.updateLanguagePreference(language)
                            }
                        }

                        Divider()
                            .padding(.vertical, 8)

                        SettingItem(
                            icon: "lock.fill",
                            label: "Privacy",
                            value: "Managed"
                        )
                    }
                    .padding(16)
                    .background(Color.white)
                    .cornerRadius(16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.gray.opacity(0.1), lineWidth: 1)
                    )

                    // Logout Button
                    Button(action: { showLogoutAlert = true }) {
                        HStack {
                            Image(systemName: "arrowtriangleright.fill")
                                .font(.system(size: 12, weight: .semibold))

                            Text("Sign Out")
                                .font(.system(size: 15, weight: .bold))
                        }
                        .foregroundStyle(.red)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.red.opacity(0.05))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.red.opacity(0.2), lineWidth: 1)
                        )
                    }

                    Spacer(minLength: 20)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 20)
                .padding(.bottom, 40)
            }

            // Header
            VStack {
                HStack {
                    Text("Profile")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(.black.opacity(0.9))

                    Spacer()

                    Button(action: {}) {
                        Image(systemName: "pencil")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(Color(red: 0.231, green: 0.51, blue: 0.96))
                            .frame(width: 40, height: 40)
                            .background(RoundedRectangle(cornerRadius: 12).fill(Color.gray.opacity(0.1)))
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color.white)
                .overlay(alignment: .bottom) {
                    Divider()
                }

                Spacer()
            }
        }
                .alert("Sign Out", isPresented: $showLogoutAlert) {
                    Button("Cancel", role: .cancel) { showLogoutAlert = false }
                    Button("Sign Out", role: .destructive) {
                        appState.isLoggedIn = false
                        userStore.clear() // optional, but usually expected on logout
                    }
                } message: {
                    Text("Are you sure you want to sign out? You'll need to sign in again to access your courses.")
                }
                .onAppear {
                    let prefs = persistenceManager.loadPreferences()
                    notificationsEnabled = prefs.notificationsEnabled
                    darkModeEnabled = prefs.darkModeEnabled
                    language = prefs.language
                }
            }
        }

struct StatCard: View {
    let icon: String
    let iconColor: Color
    let title: String
    let value: String

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundStyle(iconColor)

            VStack(spacing: 2) {
                Text(value)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.black.opacity(0.9))

                Text(title)
                    .font(.system(size: 10))
                    .foregroundStyle(.gray.opacity(0.6))
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(12)
        .background(Color.gray.opacity(0.05))
        .cornerRadius(12)
    }
}

struct SettingItem: View {
    let icon: String
    let label: String
    let value: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundStyle(Color(red: 0.231, green: 0.51, blue: 0.96))
                .frame(width: 24, alignment: .center)

            Text(label)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(.black.opacity(0.85))

            Spacer()

            Text(value)
                .font(.system(size: 13))
                .foregroundStyle(.gray.opacity(0.6))

            Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(.gray.opacity(0.4))
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(AppState())
        .environmentObject(UserStore())
}
