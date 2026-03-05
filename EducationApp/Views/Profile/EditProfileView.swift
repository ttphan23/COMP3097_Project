import SwiftUI

struct EditProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var userStore: UserStore
    
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    
    // Change Password fields
    @State private var currentPassword: String = ""
    @State private var newPassword: String = ""
    @State private var confirmNewPassword: String = ""
    
    @State private var showCurrentPassword: Bool = false
    @State private var showNewPassword: Bool = false
    @State private var showConfirmPassword: Bool = false
    
    @State private var showError = false
    @State private var errorMessage = ""
    
    private var dobText: String {
        guard let dob = userStore.currentUser?.dob else { return "Not set" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: dob)
    }
    
    private var isValidEmail: Bool {
        email.trimmingCharacters(in: .whitespacesAndNewlines).contains("@")
    }
    
    private var wantsToChangePassword: Bool {
        !currentPassword.isEmpty || !newPassword.isEmpty || !confirmNewPassword.isEmpty
    }
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            VStack(spacing: 14) {
                // Header
                HStack {
                    Button("Cancel") { dismiss() }
                        .foregroundStyle(.blue)
                    
                    Spacer()
                    
                    Text("Edit Profile")
                        .font(.headline)
                    
                    Spacer()
                    
                    Button("Save") { save() }
                        .fontWeight(.bold)
                        .foregroundStyle(.blue)
                }
                .padding(.horizontal, 16)
                .padding(.top, 10)
                
                Divider()
                
                ScrollView {
                    VStack(spacing: 12) {
                        field(title: "First Name", text: $firstName)
                        field(title: "Last Name", text: $lastName)
                        
                        // Email
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Email")
                                .font(.footnote.weight(.semibold))
                                .foregroundStyle(.black.opacity(0.65))
                            
                            TextField("alex.smith@example.com", text: $email)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled(true)
                                .keyboardType(.emailAddress)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 14)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color.gray.opacity(0.05))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 16)
                                                .stroke(Color.gray.opacity(0.15), lineWidth: 1)
                                        )
                                )
                        }
                        
                        // DOB (read-only)
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Date of Birth")
                                .font(.footnote.weight(.semibold))
                                .foregroundStyle(.black.opacity(0.65))
                            
                            HStack {
                                Text(dobText)
                                    .foregroundStyle(.black.opacity(0.7))
                                Spacer()
                                Image(systemName: "lock.fill")
                                    .foregroundStyle(.gray.opacity(0.7))
                            }
                            .padding(.horizontal, 14)
                            .padding(.vertical, 14)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.gray.opacity(0.04))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(Color.gray.opacity(0.12), lineWidth: 1)
                                    )
                            )
                        }
                        
                        // Change Password
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Change Password")
                                .font(.footnote.weight(.bold))
                                .foregroundStyle(.black.opacity(0.85))
                                .padding(.top, 6)
                            
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Current Password")
                                    .font(.footnote.weight(.semibold))
                                    .foregroundStyle(.black.opacity(0.65))
                                
                                HStack {
                                    if showCurrentPassword {
                                        TextField("Enter current password", text: $currentPassword)
                                            .textInputAutocapitalization(.never)
                                            .autocorrectionDisabled(true)
                                    } else {
                                        SecureField("Enter current password", text: $currentPassword)
                                    }
                                    
                                    Button {
                                        showCurrentPassword.toggle()
                                    } label: {
                                        Image(systemName: showCurrentPassword ? "eye.slash" : "eye")
                                            .foregroundStyle(.gray)
                                    }
                                }
                                .padding(.horizontal, 14)
                                .padding(.vertical, 14)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color.gray.opacity(0.05))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 16)
                                                .stroke(Color.gray.opacity(0.15), lineWidth: 1)
                                        )
                                )
                            }
                            
                            VStack(alignment: .leading, spacing: 6) {
                                Text("New Password")
                                    .font(.footnote.weight(.semibold))
                                    .foregroundStyle(.black.opacity(0.65))
                                
                                HStack {
                                    if showNewPassword {
                                        TextField("Min. 8 characters", text: $newPassword)
                                            .textInputAutocapitalization(.never)
                                            .autocorrectionDisabled(true)
                                    } else {
                                        SecureField("Min. 8 characters", text: $newPassword)
                                    }
                                    
                                    Button {
                                        showNewPassword.toggle()
                                    } label: {
                                        Image(systemName: showNewPassword ? "eye.slash" : "eye")
                                            .foregroundStyle(.gray)
                                    }
                                }
                                .padding(.horizontal, 14)
                                .padding(.vertical, 14)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color.gray.opacity(0.05))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 16)
                                                .stroke(Color.gray.opacity(0.15), lineWidth: 1)
                                        )
                                )
                            }
                            
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Confirm New Password")
                                    .font(.footnote.weight(.semibold))
                                    .foregroundStyle(.black.opacity(0.65))
                                
                                HStack {
                                    if showConfirmPassword {
                                        TextField("Repeat new password", text: $confirmNewPassword)
                                            .textInputAutocapitalization(.never)
                                            .autocorrectionDisabled(true)
                                    } else {
                                        SecureField("Repeat new password", text: $confirmNewPassword)
                                    }
                                    
                                    Button {
                                        showConfirmPassword.toggle()
                                    } label: {
                                        Image(systemName: showConfirmPassword ? "eye.slash" : "eye")
                                            .foregroundStyle(.gray)
                                    }
                                }
                                .padding(.horizontal, 14)
                                .padding(.vertical, 14)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color.gray.opacity(0.05))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 16)
                                                .stroke(Color.gray.opacity(0.15), lineWidth: 1)
                                        )
                                )
                            }
                        }
                        
                        if showError {
                            Text(errorMessage)
                                .font(.caption)
                                .foregroundStyle(.red)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        
                        Spacer(minLength: 10)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                    .padding(.bottom, 20)
                }
            }
        }
        .onAppear {
            firstName = userStore.currentUser?.firstName ?? ""
            lastName = userStore.currentUser?.lastName ?? ""
            email = userStore.currentUser?.email ?? ""
        }
    }
    
    private func field(title: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.footnote.weight(.semibold))
                .foregroundStyle(.black.opacity(0.65))
            
            TextField(title, text: text)
                .textInputAutocapitalization(.words)
                .autocorrectionDisabled(true)
                .padding(.horizontal, 14)
                .padding(.vertical, 14)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.gray.opacity(0.05))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.gray.opacity(0.15), lineWidth: 1)
                        )
                )
        }
    }
    
    private func save() {
        showError = false
        errorMessage = ""

        let fn = firstName.trimmingCharacters(in: .whitespacesAndNewlines)
        let ln = lastName.trimmingCharacters(in: .whitespacesAndNewlines)
        let em = email.trimmingCharacters(in: .whitespacesAndNewlines)

        if fn.isEmpty || ln.isEmpty {
            showError = true
            errorMessage = "First and last name cannot be empty."
            return
        }

        if !isValidEmail {
            showError = true
            errorMessage = "Please enter a valid email address (must include @)."
            return
        }

        // Only validate passwords if user is attempting to change password
        if wantsToChangePassword {
            guard let storedPassword = userStore.currentUser?.password else { return }

            if currentPassword != storedPassword {
                showError = true
                errorMessage = "Current password is incorrect."
                return
            }

            if newPassword.count < 8 {
                showError = true
                errorMessage = "New password must be at least 8 characters."
                return
            }

            if newPassword != confirmNewPassword {
                showError = true
                errorMessage = "New passwords do not match."
                return
            }
        }

        // Always save profile changes (with or without password update)
        do {
            try userStore.updateProfile(
                firstName: fn,
                lastName: ln,
                email: em,
                newPassword: wantsToChangePassword ? newPassword : nil
            )

            // clear fields after saving
            currentPassword = ""
            newPassword = ""
            confirmNewPassword = ""

            dismiss()
        } catch UserStore.SignUpError.emailAlreadyInUse {
            showError = true
            errorMessage = "That email is already in use. Please choose another."
        } catch {
            showError = true
            errorMessage = "Could not save changes. Please try again."
        }
    }
}
