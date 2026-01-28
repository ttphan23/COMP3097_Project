import SwiftUI

struct VerifyEmailView: View {
    @Environment(\.dismiss) private var dismiss
    let email: String

    @State private var goToWelcome = false

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

                Text("A link was sent to your inbox.\nCheck your email to start your learning journey.")
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.white.opacity(0.75))
                    .padding(.horizontal, 26)

                HStack(spacing: 10) {
                    Image(systemName: "envelope.fill")
                        .foregroundStyle(Color.blue.opacity(0.9))
                    Text(email.isEmpty ? "yourname@example.com" : email)
                        .font(.footnote.weight(.semibold))
                        .foregroundStyle(.white.opacity(0.85))
                        .lineLimit(1)
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
                .background(RoundedRectangle(cornerRadius: 14).fill(Color.white.opacity(0.08)))
                .padding(.top, 2)

                VStack(spacing: 10) {
                    Text("Didn’t see it?")
                        .font(.footnote.weight(.semibold))
                        .foregroundStyle(.white.opacity(0.55))

                    Button(action: {}) {
                        Text("Resend Link")
                            .font(.footnote.weight(.bold))
                            .foregroundStyle(Color.blue.opacity(0.95))
                            .padding(.vertical, 10)
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(Color.white.opacity(0.06))
                            )
                    }
                    .padding(.horizontal, 24)

                    Button {
                        goToWelcome = true
                    } label: {
                        Text("Back to Main Page")
                            .font(.footnote.weight(.bold))
                            .foregroundStyle(.white)
                            .padding(.vertical, 10)
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(Color.white.opacity(0.12))
                            )
                    }
                    .padding(.horizontal, 24)
                }
                .padding(.top, 8)

                NavigationLink("", isActive: $goToWelcome) {
                    WelcomeScreen()
                        .navigationBarHidden(true)
                }
                .hidden()

                Spacer()

                Text("CHANGED EMAIL ADDRESS")
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(.white.opacity(0.30))
                    .padding(.bottom, 12)
            }
        }
    }
}

#Preview {
    NavigationStack {
        VerifyEmailView(email: "alex.smith@university.edu")
    }
}
