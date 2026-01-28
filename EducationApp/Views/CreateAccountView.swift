import SwiftUI

struct CreateAccountView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""

    @State private var showEmailError: Bool = false
    @State private var showPasswordError: Bool = false

    @State private var goToVerify: Bool = false

    private var isValidEmail: Bool {
        let trimmed = email.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.contains("@")
    }

    private var passwordValid: Bool {
        password.count >= 8
    }

    private var passwordsMatch: Bool {
        !password.isEmpty && password == confirmPassword
    }

    private var canCreate: Bool {
        isValidEmail && passwordValid && passwordsMatch
    }

    var body: some View {
        ZStack {
            DottedBackground()
                .ignoresSafeArea()

            VStack(spacing: 16) {
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(.black.opacity(0.85))
                            .padding(10)
                            .background(Circle().fill(Color.black.opacity(0.06)))
                    }
                    Spacer()
                }
                .padding(.horizontal, 18)
                .padding(.top, 6)

                VStack(alignment: .leading, spacing: 10) {
                    HStack(spacing: 8) {
                        Image(systemName: "graduationcap.fill")
                            .foregroundStyle(Color.blue.opacity(0.85))
                        Text("STUDENT ACCESS ONLY")
                            .font(.caption.weight(.bold))
                            .foregroundStyle(Color.blue.opacity(0.85))
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(RoundedRectangle(cornerRadius: 14).fill(Color.blue.opacity(0.10)))

                    Text("Create Student\nAccount")
                        .font(.system(size: 34, weight: .heavy, design: .rounded))
                        .foregroundStyle(.black.opacity(0.88))

                    Text("Join your peers! Create your account to start learning.")
                        .font(.subheadline)
                        .foregroundStyle(.black.opacity(0.55))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 22)
                .padding(.top, 4)

                VStack(spacing: 14) {
                    // Email
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Email Address")
                            .font(.footnote.weight(.semibold))
                            .foregroundStyle(.black.opacity(0.65))

                        HStack {
                            Image(systemName: "at")
                                .foregroundStyle(.black.opacity(0.45))
                            TextField("john.smith@email.com", text: $email)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled(true)
                                .keyboardType(.emailAddress)

                            if showEmailError {
                                Image(systemName: "exclamationmark.circle.fill")
                                    .foregroundStyle(.red)
                            }
                        }
                        .padding(.horizontal, 14)
                        .padding(.vertical, 14)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(showEmailError ? Color.red : Color.black.opacity(0.08), lineWidth: showEmailError ? 2 : 1)
                                )
                        )

                        if showEmailError {
                            Text("Please enter a valid email address).")
                                .font(.caption)
                                .foregroundStyle(.red)
                        }
                    }

                    // Password
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Choose Password")
                            .font(.footnote.weight(.semibold))
                            .foregroundStyle(.black.opacity(0.65))

                        SecureField("Min. 8 characters", text: $password)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 14)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.white)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(showPasswordError ? Color.red : Color.black.opacity(0.08), lineWidth: showPasswordError ? 2 : 1)
                                    )
                            )
                    }

                    // Confirm password
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Confirm Password")
                            .font(.footnote.weight(.semibold))
                            .foregroundStyle(.black.opacity(0.65))

                        SecureField("Repeat password", text: $confirmPassword)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 14)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.white)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(showPasswordError ? Color.red : Color.black.opacity(0.08), lineWidth: showPasswordError ? 2 : 1)
                                    )
                            )

                        if showPasswordError {
                            Text("Password must be 8+ characters and match.")
                                .font(.caption)
                                .foregroundStyle(.red)
                        }
                    }

                    // Create Account button (navigates to Verify screen)
                    Button {
                        // UI-only validation
                        showEmailError = !isValidEmail
                        showPasswordError = !(passwordValid && passwordsMatch)

                        if canCreate {
                            goToVerify = true
                        }
                    } label: {
                        HStack {
                            Text("Create Account")
                                .font(.system(size: 16, weight: .bold, design: .rounded))
                            Spacer()
                            Image(systemName: "arrow.right")
                                .font(.system(size: 14, weight: .bold))
                        }
                        .foregroundStyle(canCreate ? Color.white : Color.black.opacity(0.35))
                        .padding(.horizontal, 18)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 18)
                                .fill(canCreate ? Color.blue : Color.black.opacity(0.10))
                        )
                    }
                    .padding(.top, 6)

                    HStack(spacing: 6) {
                        Text("Already part of the community?")
                            .foregroundStyle(.black.opacity(0.55))
                        NavigationLink {
                            SignInView()
                                .navigationBarHidden(true)
                        } label: {
                            Text("Log In")
                                .fontWeight(.bold)
                                .foregroundStyle(Color.blue)
                        }
                    }
                    .font(.footnote)
                    .padding(.top, 6)
                }
                .padding(.horizontal, 22)

                Spacer()

                // Hidden navigation trigger
                NavigationLink("", isActive: $goToVerify) {
                    VerifyEmailView(email: email)
                        .navigationBarHidden(true)
                }
                .hidden()
            }
        }
        .onChange(of: email) { _ in
            if showEmailError { showEmailError = false }
        }
        .onChange(of: password) { _ in
            if showPasswordError { showPasswordError = false }
        }
        .onChange(of: confirmPassword) { _ in
            if showPasswordError { showPasswordError = false }
        }
    }
}

struct DottedBackground: View {
    var body: some View {
        Color.white
            .overlay(
                GeometryReader { geo in
                    let w = geo.size.width
                    let h = geo.size.height
                    Path { path in
                        let step: CGFloat = 22
                        var y: CGFloat = 0
                        while y < h {
                            var x: CGFloat = 0
                            while x < w {
                                path.addEllipse(in: CGRect(x: x, y: y, width: 2.2, height: 2.2))
                                x += step
                            }
                            y += step
                        }
                    }
                    .fill(Color.black.opacity(0.06))
                }
            )
    }
}

#Preview {
    NavigationStack {
        CreateAccountView()
    }
}
