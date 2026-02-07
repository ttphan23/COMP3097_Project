import SwiftUI

struct WelcomeScreen: View {
    @Binding var isLoggedIn: Bool

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.98, green: 0.78, blue: 0.50),
                    Color(red: 0.93, green: 0.60, blue: 0.42)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            PatternOverlay()
                .opacity(0.25)
                .ignoresSafeArea()

                VStack(spacing: 16) {
                    ZStack {
                        Circle().fill(Color(red: 0.10, green: 0.27, blue: 0.55))
                        Circle().stroke(Color.yellow.opacity(0.9), lineWidth: 4)

                        Image(systemName: "graduationcap.fill")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundStyle(.yellow)
                    }
                    .frame(width: 72, height: 72)
                    .padding(.top, 6)

                    Text("EduVantage")
                        .font(.system(size: 30, weight: .heavy, design: .rounded))
                        .foregroundStyle(Color(red: 0.10, green: 0.27, blue: 0.55))

                    ZStack {
                        RoundedRectangle(cornerRadius: 18)
                            .fill(Color.white.opacity(0.20))
                        RoundedRectangle(cornerRadius: 18)
                            .stroke(style: StrokeStyle(lineWidth: 2, dash: [8, 6]))
                            .foregroundStyle(Color.white.opacity(0.55))

                        if let _ = UIImage(named: "WelcomeHero") {
                            Image("WelcomeHero")
                                .resizable()
                                .scaledToFill()
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .padding(10)
                        } else {
                            Image(systemName: "books.vertical.fill")
                                .font(.system(size: 42))
                                .foregroundStyle(.white.opacity(0.85))
                        }
                    }
                    .frame(height: 170)
                    .padding(.horizontal, 8)

                    VStack(spacing: 6) {
                        Text("Master your courses")
                            .font(.system(size: 22, weight: .heavy, design: .rounded))
                            .foregroundStyle(Color(red: 0.10, green: 0.27, blue: 0.55))

                        Text("with ease")
                            .font(.system(size: 22, weight: .heavy, design: .rounded))
                            .foregroundStyle(Color(red: 0.10, green: 0.27, blue: 0.55))
                            .padding(.horizontal, 14)
                            .padding(.vertical, 6)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.yellow.opacity(0.9))
                            )
                    }

                    Text("The friendly learning companion\nbuilt just for university students.")
                        .font(.footnote)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.white.opacity(0.90))
                        .padding(.top, 2)

                    VStack(spacing: 12) {
                        NavigationLink {
                            CreateAccountView(isLoggedIn: $isLoggedIn)
                                .navigationBarHidden(true)
                        } label: {
                            Text("Create Student Account")
                                .font(.system(size: 16, weight: .bold, design: .rounded))
                                .foregroundStyle(Color(red: 0.10, green: 0.27, blue: 0.55))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(RoundedRectangle(cornerRadius: 14).fill(Color.yellow))
                                .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.black.opacity(0.15), lineWidth: 1))
                        }

                        NavigationLink {
                            SignInView(isLoggedIn: $isLoggedIn)
                                .navigationBarHidden(true)
                        } label: {
                            Text("Sign In")
                                .font(.system(size: 16, weight: .bold, design: .rounded))
                                .foregroundStyle(Color(red: 0.10, green: 0.27, blue: 0.55))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(RoundedRectangle(cornerRadius: 14).fill(Color.white))
                                .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.black.opacity(0.10), lineWidth: 1))
                        }
                    }
                    .padding(.top, 6)
                }
                .padding(18)
                .background(RoundedRectangle(cornerRadius: 26).fill(Color.white.opacity(0.18)))
                .overlay(RoundedRectangle(cornerRadius: 26).stroke(Color.white.opacity(0.25), lineWidth: 1))
                .padding(.horizontal, 18)

                Spacer(minLength: 12)
            }
        }
    }

struct PatternOverlay: View {
    var body: some View {
        GeometryReader { geo in
            let size = geo.size
            Path { path in
                let step: CGFloat = 18
                var x: CGFloat = 0
                while x <= size.width {
                    path.move(to: CGPoint(x: x, y: 0))
                    path.addLine(to: CGPoint(x: x, y: size.height))
                    x += step
                }
                var y: CGFloat = 0
                while y <= size.height {
                    path.move(to: CGPoint(x: 0, y: y))
                    path.addLine(to: CGPoint(x: size.width, y: y))
                    y += step
                }
            }
            .stroke(Color.white.opacity(0.45), lineWidth: 1)
        }
    }
}

#Preview {
    WelcomeScreen(isLoggedIn: .constant(false))
}
