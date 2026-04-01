import SwiftUI

struct ProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var isLoggedIn: Bool
    @StateObject private var persistenceManager = DataPersistenceManager.shared
    @StateObject private var loc = LocalizationManager.shared

    @State private var showLogoutAlert: Bool = false
    @State private var showEditProfile: Bool = false
    @State private var notificationsEnabled: Bool = true
    @State private var darkModeEnabled: Bool = false
    @State private var language: String = "English"
    @State private var stats = (totalCoursesEnrolled: 0, totalCoursesCompleted: 0, totalLessonsCompleted: 0, averageProgress: 0.0)

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text(loc.localized("Profile"))
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(Color(.label).opacity(0.9))

                Spacer()

                Button(action: { showEditProfile = true }) {
                    HStack(spacing: 6) {
                        Image(systemName: "pencil")
                            .font(.system(size: 14, weight: .semibold))
                        Text("Edit Profile")
                            .font(.system(size: 14, weight: .semibold))
                    }
                    .foregroundStyle(Color(red: 0.231, green: 0.51, blue: 0.96))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(.secondarySystemBackground))
                    )
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color(.systemBackground))
            .overlay(alignment: .bottom) {
                Divider()
            }

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

                        VStack(spacing: 6) {
                            Text("\(persistenceManager.currentUser?.firstName ?? "") \(persistenceManager.currentUser?.lastName ?? "")")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundStyle(Color(.label).opacity(0.9))

                            Text(persistenceManager.currentUser?.email ?? "student@university.edu")
                                .font(.system(size: 13))
                                .foregroundStyle(Color(.secondaryLabel))

                            Text("DOB: \(formattedDOB)")
                                .font(.system(size: 12))
                                .foregroundStyle(Color(.secondaryLabel))
                        }

                        HStack(spacing: 8) {
                            Image(systemName: "checkmark.seal.fill")
                                .font(.system(size: 12))
                                .foregroundStyle(Color.green)

                            Text("\(persistenceManager.currentUser?.university ?? "University") Verified")
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
                    .background(Color(.secondarySystemBackground).opacity(0.5))
                    .cornerRadius(16)

                    // Personal Information
                    VStack(spacing: 12) {
                        Text("Personal Information")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(Color(.label).opacity(0.9))
                            .frame(maxWidth: .infinity, alignment: .leading)

                        profileInfoRow(label: "First Name", value: persistenceManager.currentUser?.firstName ?? "")
                        profileInfoRow(label: "Last Name", value: persistenceManager.currentUser?.lastName ?? "")
                        profileInfoRow(label: "Email", value: persistenceManager.currentUser?.email ?? "")
                        profileInfoRow(label: "Date of Birth", value: formattedDOB)
                    }
                    .padding(16)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.gray.opacity(0.1), lineWidth: 1)
                    )

                    // Stats
                    VStack(spacing: 12) {
                        Text(loc.localized("Learning Stats"))
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(Color(.label).opacity(0.9))
                            .frame(maxWidth: .infinity, alignment: .leading)

                        HStack(spacing: 12) {
                            StatCard(
                                icon: "book.fill",
                                iconColor: Color.blue,
                                title: loc.localized("Courses Enrolled"),
                                value: "\(stats.totalCoursesEnrolled)"
                            )

                            StatCard(
                                icon: "checkmark.circle.fill",
                                iconColor: Color.green,
                                title: loc.localized("Completed"),
                                value: "\(stats.totalCoursesCompleted)"
                            )

                            StatCard(
                                icon: "flame.fill",
                                iconColor: Color.orange,
                                title: loc.localized("Lessons Done"),
                                value: "\(stats.totalLessonsCompleted)"
                            )
                        }
                    }
                    .padding(16)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.gray.opacity(0.1), lineWidth: 1)
                    )

                    // Settings Section
                    VStack(spacing: 0) {
                        Text(loc.localized("Settings"))
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(Color(.label).opacity(0.9))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.bottom, 12)

                        HStack(spacing: 12) {
                            Image(systemName: "bell.fill")
                                .font(.system(size: 14))
                                .foregroundStyle(Color(red: 0.231, green: 0.51, blue: 0.96))
                                .frame(width: 24, alignment: .center)

                            Text(loc.localized("Notifications"))
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(Color(.label).opacity(0.85))

                            Spacer()

                            Toggle("", isOn: $notificationsEnabled)
                                .onChange(of: notificationsEnabled) {
                                    persistenceManager.updateNotificationPreference(notificationsEnabled)
                                }
                        }

                        Divider()
                            .padding(.vertical, 8)

                        HStack(spacing: 12) {
                            Image(systemName: "moon.fill")
                                .font(.system(size: 14))
                                .foregroundStyle(Color(red: 0.231, green: 0.51, blue: 0.96))
                                .frame(width: 24, alignment: .center)

                            Text(loc.localized("Dark Mode"))
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(Color(.label).opacity(0.85))

                            Spacer()

                            Toggle("", isOn: $darkModeEnabled)
                                .onChange(of: darkModeEnabled) {
                                    persistenceManager.updateDarkModePreference(darkModeEnabled)
                                }
                        }

                        Divider()
                            .padding(.vertical, 8)

                        HStack(spacing: 12) {
                            Image(systemName: "globe")
                                .font(.system(size: 14))
                                .foregroundStyle(Color(red: 0.231, green: 0.51, blue: 0.96))
                                .frame(width: 24, alignment: .center)

                            Text(loc.localized("Language"))
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(Color(.label).opacity(0.85))

                            Spacer()

                            Picker("", selection: $language) {
                                Text("English").tag("English")
                                Text("Spanish").tag("Spanish")
                                Text("French").tag("French")
                                Text("German").tag("German")
                            }
                            .onChange(of: language) {
                                persistenceManager.updateLanguagePreference(language)
                                loc.currentLanguage = language
                            }
                        }

                        Divider()
                            .padding(.vertical, 8)

                        SettingItem(
                            icon: "lock.fill",
                            label: loc.localized("Privacy"),
                            value: "Managed"
                        )
                    }
                    .padding(16)
                    .background(Color(.secondarySystemBackground))
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

                            Text(loc.localized("Sign Out"))
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
                .padding(.top, 20)
                .padding(.bottom, 20)
            }
        }
        .background(Color(.systemBackground))
        .alert("Sign Out", isPresented: $showLogoutAlert) {
            Button("Cancel", role: .cancel) {
                showLogoutAlert = false
            }
            Button("Sign Out", role: .destructive) {
                persistenceManager.signOutUser()
                isLoggedIn = false
            }
        } message: {
            Text("Are you sure you want to sign out? You'll need to sign in again to access your courses.")
        }
        .sheet(isPresented: $showEditProfile) {
            EditProfileSheet(persistenceManager: persistenceManager)
        }
        .onAppear {
            let prefs = persistenceManager.loadPreferences()
            notificationsEnabled = prefs.notificationsEnabled
            darkModeEnabled = prefs.darkModeEnabled
            language = prefs.language
            loc.currentLanguage = prefs.language
            stats = persistenceManager.getAppStatistics()
        }
    }

    private var formattedDOB: String {
        guard let dob = persistenceManager.currentUser?.dob else { return "Not set" }
        return dob.formatted(date: .abbreviated, time: .omitted)
    }

    @ViewBuilder
    private func profileInfoRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(Color(.label).opacity(0.85))

            Spacer()

            Text(value.isEmpty ? "Not set" : value)
                .font(.system(size: 14))
                .foregroundStyle(Color(.secondaryLabel))
                .multilineTextAlignment(.trailing)
        }
    }
}

// MARK: - Edit Profile Sheet

struct EditProfileSheet: View {
    @Environment(\.dismiss) private var dismiss
    let persistenceManager: DataPersistenceManager

    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State private var password: String = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("Personal Information") {
                    TextField("First Name", text: $firstName)
                    TextField("Last Name", text: $lastName)

                    TextField("Email", text: $email)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)

                    SecureField("Change Password", text: $password)
                }

                Section("Date of Birth") {
                    Text(
                        persistenceManager.currentUser?.dob.formatted(date: .abbreviated, time: .omitted)
                        ?? "Not set"
                    )
                    .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        guard !firstName.isEmpty, !lastName.isEmpty, !email.isEmpty, !password.isEmpty else { return }

                        persistenceManager.updateUserProfile(
                            firstName: firstName,
                            lastName: lastName,
                            email: email,
                            password: password
                        )

                        dismiss()
                    }
                    .disabled(firstName.isEmpty || lastName.isEmpty || email.isEmpty || password.isEmpty)
                }
            }
            .onAppear {
                firstName = persistenceManager.currentUser?.firstName ?? ""
                lastName = persistenceManager.currentUser?.lastName ?? ""
                email = persistenceManager.currentUser?.email ?? ""
                password = persistenceManager.currentUser?.password ?? ""
            }
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
                    .foregroundStyle(Color(.label).opacity(0.9))

                Text(title)
                    .font(.system(size: 10))
                    .foregroundStyle(Color(.secondaryLabel))
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(12)
        .background(Color(.tertiarySystemBackground))
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
                .foregroundStyle(Color(.label).opacity(0.85))

            Spacer()

            Text(value)
                .font(.system(size: 13))
                .foregroundStyle(Color(.secondaryLabel))

            Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(Color(.tertiaryLabel))
        }
    }
}

#Preview {
    ProfileView(isLoggedIn: .constant(true))
}
