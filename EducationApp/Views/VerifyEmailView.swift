import SwiftUI

struct VerifyEmailView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var isLoggedIn: Bool

    let email: String
    let firstName: String
    let lastName: String
    let dob: Date
    let password: String

    @StateObject private var persistenceManager = DataPersistenceManager.shared
    @StateObject private var verificationService = EmailVerificationService.shared

    @State private var enteredCode: String = ""
    @State private var showCodeError: Bool = false
    @State private var codeErrorMessage: String = ""
    @State private var resendMessage: String = ""
    @State private var canResend: Bool = false
    @State private var cooldownSeconds: Int = 0
    @State private var cooldownTimer: Timer? = nil

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.05, green: 0.08, blue: 0.14),
                    Color(red: 0.03, green: 0.05, blue: 0.10)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 18) {
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .foregroundStyle(.white.opacity(0.85))
                            .padding(10)
                            .background(Circle().fill(Color.white.opacity(0.08)))
                    }

                    Spacer()

                    HStack(spacing: 8) {
                        Capsule().fill(Color.white.opacity(0.18)).frame(width: 22, height: 4)
                        Capsule().fill(Color.blue).frame(width: 28, height: 4)
                        Capsule().fill(Color.white.opacity(0.18)).frame(width: 22, height: 4)
                    }

                    Spacer()
                    Color.clear.frame(width: 38, height: 38)
                }
                .padding(.horizontal, 18)
                .padding(.top, 6)

                ZStack {
                    Circle()
                        .fill(Color.blue.opacity(0.12))
                        .frame(width: 140, height: 140)

                    Circle()
                        .stroke(style: StrokeStyle(lineWidth: 2, dash: [6, 6]))
                        .foregroundStyle(Color.blue.opacity(0.25))
                        .frame(width: 140, height: 140)

                    Image(systemName: "paperplane.fill")
                        .font(.system(size: 44, weight: .bold))
                        .foregroundStyle(Color.blue)
                }
                .padding(.top, 10)

                Text("Verify Your Email")
                    .font(.system(size: 28, weight: .heavy, design: .rounded))
                    .foregroundStyle(.white)

                if verificationService.isSending {
                    HStack(spacing: 8) {
                        ProgressView()
                            .tint(.white)
                        Text("Sending verification code...")
                            .font(.subheadline)
                            .foregroundStyle(.white.opacity(0.75))
                    }
                } else if verificationService.isCodeSent {
                    Text("A 6-digit code has been sent to your email.\nEnter it below to verify.")
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.white.opacity(0.75))
                        .padding(.horizontal, 26)
                } else if let error = verificationService.sendError {
                    Text(error)
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.red.opacity(0.9))
                        .padding(.horizontal, 26)
                }

                HStack(spacing: 10) {
                    Image(systemName: "envelope.fill")
                        .foregroundStyle(Color.blue.opacity(0.9))

                    Text(email)
                        .font(.footnote.weight(.semibold))
                        .foregroundStyle(.white.opacity(0.85))
                        .lineLimit(1)
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(Color.white.opacity(0.08))
                )
                .padding(.top, 2)

                // Verification code input
                VStack(spacing: 8) {
                    TextField("", text: $enteredCode)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.center)
                        .font(.system(size: 28, weight: .bold, design: .monospaced))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 14)
                        .frame(width: 200)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(Color.white.opacity(0.08))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 14)
                                        .stroke(showCodeError ? Color.red : Color.white.opacity(0.15), lineWidth: showCodeError ? 2 : 1)
                                )
                        )
                        .overlay(
                            Group {
                                if enteredCode.isEmpty {
                                    Text("000000")
                                        .font(.system(size: 28, weight: .bold, design: .monospaced))
                                        .foregroundStyle(.white.opacity(0.25))
                                }
                            }
                        )
                        .onChange(of: enteredCode) { _, newValue in
                            let filtered = newValue.filter { $0.isNumber }
                            if filtered.count > 6 {
                                enteredCode = String(filtered.prefix(6))
                            } else {
                                enteredCode = filtered
                            }
                            if showCodeError { showCodeError = false }
                        }

                    if showCodeError {
                        Text(codeErrorMessage)
                            .font(.caption)
                            .foregroundStyle(.red)
                    }
                }

                VStack(spacing: 10) {
                    // Verify button
                    Button {
                        if enteredCode.count != 6 {
                            codeErrorMessage = "Please enter the 6-digit code."
                            showCodeError = true
                            return
                        }

                        if verificationService.verifyCode(enteredCode) {
                            let domain = email.components(separatedBy: "@").last ?? ""

                            let university: String
                            if domain.contains(".edu") {
                                let cleaned = domain.replacingOccurrences(of: ".edu", with: "")
                                university = cleaned.capitalized + " University"
                            } else {
                                university = "Verified Student"
                            }

                            let user = UserProfile(
                                id: UUID().uuidString,
                                name: "\(firstName) \(lastName)",
                                firstName: firstName,
                                lastName: lastName,
                                dob: dob,
                                email: email,
                                password: password,
                                university: university,
                                profileImageURL: nil,
                                createdDate: Date(),
                                coursesEnrolled: [],
                                coursesCompleted: 0,
                                streakDays: 0,
                                lastActiveDate: nil
                            )

                            persistenceManager.saveCurrentUser(user)
                            isLoggedIn = true
                        } else {
                            codeErrorMessage = "Invalid code. Please try again."
                            showCodeError = true
                        }
                    } label: {
                        Text("Verify & Continue")
                            .font(.footnote.weight(.bold))
                            .foregroundStyle(.white)
                            .padding(.vertical, 12)
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(enteredCode.count == 6 ? Color.blue : Color.blue.opacity(0.4))
                            )
                    }
                    .padding(.horizontal, 24)

                    Text("Didn't receive the code?")
                        .font(.footnote.weight(.semibold))
                        .foregroundStyle(.white.opacity(0.55))
                        .padding(.top, 4)

                    Button(action: {
                        guard canResend else { return }
                        sendVerificationEmail()
                    }) {
                        Text(resendMessage.isEmpty ? "Resend Code" : resendMessage)
                            .font(.footnote.weight(.bold))
                            .foregroundStyle(canResend ? Color.blue.opacity(0.95) : Color.white.opacity(0.3))
                            .padding(.vertical, 10)
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(Color.white.opacity(0.06))
                            )
                    }
                    .disabled(!canResend)
                    .padding(.horizontal, 24)
                }
                .padding(.top, 8)

                Spacer()
            }
        }
        .onAppear {
            sendVerificationEmail()
        }
        .onDisappear {
            cooldownTimer?.invalidate()
        }
    }

    private func sendVerificationEmail() {
        enteredCode = ""
        showCodeError = false
        verificationService.sendVerificationEmail(to: email) { success in
            if success {
                startCooldown()
            } else {
                canResend = true
                resendMessage = ""
            }
        }
    }

    private func startCooldown() {
        canResend = false
        cooldownSeconds = 30
        resendMessage = "Resend in 30s"

        cooldownTimer?.invalidate()
        cooldownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            cooldownSeconds -= 1
            if cooldownSeconds > 0 {
                resendMessage = "Resend in \(cooldownSeconds)s"
            } else {
                resendMessage = ""
                canResend = true
                timer.invalidate()
            }
        }
    }
}

#Preview {
    NavigationStack {
        VerifyEmailView(
            isLoggedIn: .constant(false),
            email: "student@university.edu",
            firstName: "Alex",
            lastName: "Smith",
            dob: Date(),
            password: "Password123"
        )
    }
}
