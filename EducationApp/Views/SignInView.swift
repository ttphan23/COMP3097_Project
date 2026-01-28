import SwiftUI

struct SignInView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var email: String = ""
    @State private var password: String = ""

    @State private var showError: Bool = false

    private var isValidEmail: Bool {
        let trimmed = email.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.contains("@")
    }

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            DottedBackground().ignoresSafeArea()

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
                    Text("Sign In")
                        .font(.system(size: 34, weight: .heavy, design: .rounded))
                        .foregroundStyle(.black.opacity(0.88))

                    Text("Use your email and password to continue.")
                        .font(.subheadline)
                        .foregroundStyle(.black.opacity(0.55))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 22)
                .padding(.top, 4)

                VStack(spacing: 14) {
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
                                    .fill(Color.white)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(showError ? Color.red : Color.black.opacity(0.08), lineWidth: showError ? 2 : 1)
                                    )
                            )
                    }

                    // Password
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Password")
                            .font(.footnote.weight(.semibold))
                            .foregroundStyle(.black.opacity(0.65))

                        SecureField("Your password", text: $password)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 14)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.white)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(showError ? Color.red : Color.black.opacity(0.08), lineWidth: showError ? 2 : 1)
                                    )
                            )
                    }

                    if showError {
                        Text("Please enter a valid email address (must include @). (No real login yet)")
                            .font(.caption)
                            .foregroundStyle(.red)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }

                    Button {
                        // UI-only validation
                        showError = !isValidEmail
                    } label: {
                        Text("Sign In")
                            .font(.system(size: 16, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(RoundedRectangle(cornerRadius: 18).fill(Color.blue))
                    }
                    .padding(.top, 6)
                }
                .padding(.horizontal, 22)

                Spacer()
            }
        }
        .onChange(of: email) { _ in
            if showError { showError = false }
        }
    }
}

#Preview {
    NavigationStack {
        SignInView()
    }
}
