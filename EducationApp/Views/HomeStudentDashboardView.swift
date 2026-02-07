import SwiftUI

struct HomeStudentDashboardView: View {
    @StateObject private var persistenceManager = DataPersistenceManager.shared
    @State private var stats = (totalCoursesEnrolled: 0, totalCoursesCompleted: 0, totalLessonsCompleted: 0, averageProgress: 0.0)

    var body: some View {
        ZStack {
            Color(red: 0.99, green: 0.99, blue: 0.976).ignoresSafeArea()

            VStack(spacing: 0) {
                // Header
                HStack(alignment: .center, spacing: 12) {
                    Image(systemName: "person.crop.circle.fill")
                        .font(.system(size: 40))
                        .foregroundStyle(Color(red: 1, green: 0.49, blue: 0.37))
                        .frame(width: 48, height: 48)
                        .background(RoundedRectangle(cornerRadius: 12).fill(Color.white))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color(red: 1, green: 0.73, blue: 0.48), lineWidth: 2)
                        )

                    VStack(alignment: .leading, spacing: 2) {
                        Text("STANFORD.EDU")
                            .font(.system(size: 9, weight: .bold))
                            .tracking(0.5)
                            .foregroundStyle(Color(red: 1, green: 0.49, blue: 0.37))

                        Text("Home")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundStyle(.black.opacity(0.9))
                    }

                    Spacer()

                    Button(action: {}) {
                        Image(systemName: "bell.badge.fill")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(Color(red: 1, green: 0.49, blue: 0.37))
                            .frame(width: 44, height: 44)
                            .background(RoundedRectangle(cornerRadius: 12).fill(Color.white))
                            .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 2)
                    }
                }
                .padding(.horizontal, 18)
                .padding(.top, 12)
                .padding(.bottom, 8)

                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 20) {
                        // Greeting Section
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Hi, Alex! 👋")
                                .font(.system(size: 32, weight: .bold, design: .rounded))
                                .foregroundStyle(.black.opacity(0.9))

                            Text("Ready for a super productive day?")
                                .font(.system(size: 16))
                                .foregroundStyle(.black.opacity(0.5))
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 18)
                        .padding(.top, 8)

                        // Your Week Progress Card
                        VStack(spacing: 0) {
                            HStack(spacing: 16) {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Your Week")
                                        .font(.system(size: 18, weight: .bold, design: .rounded))
                                        .foregroundStyle(.black.opacity(0.9))

                                    Text("85% of your target reached")
                                        .font(.system(size: 13))
                                        .foregroundStyle(.black.opacity(0.5))

                                    HStack(spacing: 8) {
                                        Image(systemName: "party.popper.fill")
                                            .font(.system(size: 14))
                                        Text("Keep it up!")
                                            .font(.system(size: 11, weight: .bold))
                                    }
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .background(Color(red: 0.86, green: 0.99, blue: 0.84))
                                    .foregroundStyle(Color(red: 0.1, green: 0.55, blue: 0.1))
                                    .cornerRadius(12)
                                }

                                Spacer()

                                // Progress Circle
                                ZStack {
                                    Circle()
                                        .stroke(Color.black.opacity(0.08), lineWidth: 8)

                                    Circle()
                                        .trim(from: 0, to: 0.85)
                                        .stroke(
                                            LinearGradient(
                                                gradient: Gradient(colors: [
                                                    Color(red: 1, green: 0.49, blue: 0.37),
                                                    Color(red: 1, green: 0.73, blue: 0.48)
                                                ]),
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ),
                                            style: StrokeStyle(lineWidth: 8, lineCap: .round)
                                        )
                                        .rotationEffect(.degrees(-90))

                                    VStack(spacing: 2) {
                                        Text("85%")
                                            .font(.system(size: 16, weight: .bold, design: .rounded))
                                            .foregroundStyle(.black.opacity(0.85))
                                    }
                                }
                                .frame(width: 100, height: 100)
                            }
                            .padding(16)
                            .background(Color.white)
                            .cornerRadius(16)
                        }
                        .padding(.horizontal, 18)
                        .shadow(color: Color.black.opacity(0.05), radius: 12, x: 0, y: 4)

                        // Keep Going Section
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("Keep Going! 🚀")
                                    .font(.system(size: 22, weight: .bold, design: .rounded))
                                    .foregroundStyle(.black.opacity(0.9))

                                Spacer()

                                Button("See All") {
                                    // Navigation action
                                }
                                .font(.system(size: 13, weight: .bold))
                                .foregroundStyle(Color(red: 1, green: 0.49, blue: 0.37))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color(red: 1, green: 0.9, blue: 0.95).opacity(0.5))
                                .cornerRadius(12)
                            }
                            .padding(.horizontal, 18)

                            // Course Card
                            VStack(spacing: 0) {
                                ZStack(alignment: .topLeading) {
                                    Image(systemName: "book.circle.fill")
                                        .font(.system(size: 120))
                                        .foregroundStyle(Color.purple.opacity(0.15))
                                        .frame(maxWidth: .infinity, maxHeight: 140, alignment: .bottomTrailing)
                                        .offset(x: 20, y: -20)

                                    VStack(alignment: .leading, spacing: 8) {
                                        HStack(spacing: 6) {
                                            Image(systemName: "book.fill")
                                                .font(.system(size: 11))
                                                .foregroundStyle(Color.purple)

                                            Text("LESSON 4")
                                                .font(.system(size: 9, weight: .bold))
                                                .tracking(0.5)
                                                .foregroundStyle(Color.purple)
                                        }
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 4)
                                        .background(Color.white.opacity(0.85))
                                        .cornerRadius(12)
                                    }
                                    .padding(12)
                                }
                                .frame(height: 140)
                                .background(Color(red: 0.95, green: 0.91, blue: 0.99).opacity(0.3))

                                VStack(alignment: .leading, spacing: 12) {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Advanced Astrophysics")
                                            .font(.system(size: 16, weight: .bold, design: .rounded))
                                            .foregroundStyle(.black.opacity(0.9))

                                        Text("Orbital Mechanics • 12 mins left")
                                            .font(.system(size: 12))
                                            .foregroundStyle(.black.opacity(0.5))
                                    }

                                    // Progress Bar
                                    VStack(spacing: 8) {
                                        ZStack(alignment: .leading) {
                                            RoundedRectangle(cornerRadius: 4)
                                                .fill(Color.white.opacity(0.5))

                                            RoundedRectangle(cornerRadius: 4)
                                                .fill(
                                                    LinearGradient(
                                                        gradient: Gradient(colors: [
                                                            Color(red: 1, green: 0.49, blue: 0.37),
                                                            Color(red: 1, green: 0.73, blue: 0.48)
                                                        ]),
                                                        startPoint: .leading,
                                                        endPoint: .trailing
                                                    )
                                                )
                                                .frame(width: 66)
                                        }
                                        .frame(height: 8)

                                        HStack {
                                            Text("33% Done")
                                                .font(.system(size: 12, weight: .bold))
                                                .foregroundStyle(Color(red: 1, green: 0.49, blue: 0.37))

                                            Spacer()

                                            Button("Jump back in") {
                                                // Navigation action
                                            }
                                            .font(.system(size: 12, weight: .bold))
                                            .foregroundStyle(.white)
                                            .frame(minWidth: 100)
                                            .padding(.vertical, 8)
                                            .background(Color(red: 1, green: 0.49, blue: 0.37))
                                            .cornerRadius(12)
                                            .shadow(color: Color(red: 1, green: 0.7, blue: 0.6).opacity(0.4), radius: 6, x: 0, y: 2)
                                        }
                                    }
                                }
                                .padding(16)
                                .background(Color.white)
                            }
                            .cornerRadius(16)
                            .padding(.horizontal, 18)
                            .shadow(color: Color.black.opacity(0.05), radius: 12, x: 0, y: 4)
                        }

                        // Don't Forget Section
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Don't Forget! ✏️")
                                .font(.system(size: 22, weight: .bold, design: .rounded))
                                .foregroundStyle(.black.opacity(0.9))
                                .padding(.horizontal, 18)

                            VStack(spacing: 12) {
                                // History Essay
                                AssignmentCard(
                                    icon: "book.fill",
                                    iconColor: Color(red: 0.95, green: 0.5, blue: 0.7),
                                    backgroundColor: Color(red: 0.98, green: 0.91, blue: 0.97).opacity(0.4),
                                    borderColor: Color.pink.opacity(0.2),
                                    title: "History Essay",
                                    subtitle: "Modern World History",
                                    deadline: "2h Left!",
                                    deadlineColor: Color(red: 0.9, green: 0.4, blue: 0.5),
                                    date: "Today, 11:59 PM"
                                )

                                // Calculus Quiz
                                AssignmentCard(
                                    icon: "function",
                                    iconColor: Color.blue,
                                    backgroundColor: Color(red: 0.88, green: 0.95, blue: 0.99).opacity(0.4),
                                    borderColor: Color.blue.opacity(0.2),
                                    title: "Calculus Quiz",
                                    subtitle: "Differentiation Rules",
                                    deadline: "Tomorrow",
                                    deadlineColor: Color.blue,
                                    date: "Oct 24, 2:00 PM"
                                )

                                // Physics Lab
                                AssignmentCard(
                                    icon: "flask.fill",
                                    iconColor: Color(red: 1, green: 0.8, blue: 0),
                                    backgroundColor: Color(red: 0.99, green: 0.98, blue: 0.88).opacity(0.4),
                                    borderColor: Color(red: 1, green: 0.9, blue: 0.2).opacity(0.2),
                                    title: "Physics Lab",
                                    subtitle: "Electromagnetism",
                                    deadline: "Oct 26",
                                    deadlineColor: Color(red: 0.95, green: 0.75, blue: 0),
                                    date: "Friday, 5:00 PM"
                                )
                            }
                            .padding(.horizontal, 18)
                        }

                        // Stanford Member Badge
                        VStack {
                            HStack(spacing: 8) {
                                Image(systemName: "checkmark.seal.fill")
                                    .font(.system(size: 16))
                                    .foregroundStyle(Color.green)

                                Text("STANFORD EDU MEMBER")
                                    .font(.system(size: 10, weight: .bold))
                                    .tracking(0.3)
                                    .foregroundStyle(Color(red: 0.1, green: 0.55, blue: 0.1))
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(Color(red: 0.86, green: 0.99, blue: 0.84).opacity(0.5))
                            .cornerRadius(12)
                            .border(Color.green.opacity(0.2), width: 1)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 18)
                        .padding(.vertical, 12)
                        .padding(.bottom, 45)

                        Spacer(minLength: 20)
                    }
                }

                Spacer(minLength: 0)
            }

            // Bottom Navigation
            VStack(spacing: 0) {
                Spacer()

                HStack(spacing: 0) {
                    TabBarItem(icon: "house.fill", label: "Home", isActive: true)
                    TabBarItem(icon: "book.fill", label: "Courses", isActive: false)
                    TabBarItem(icon: "calendar", label: "Plan", isActive: false)
                    TabBarItem(icon: "smiley.fill", label: "Me", isActive: false)
                }
                .frame(height: 80)
                .background(Color.white.opacity(0.9))
                .overlay(alignment: .top) {
                    Divider()
                }
                .blur(radius: 0.5)
            }
        }
        .onAppear {
            stats = persistenceManager.getAppStatistics()
        }
    }
}

struct AssignmentCard: View {
    let icon: String
    let iconColor: Color
    let backgroundColor: Color
    let borderColor: Color
    let title: String
    let subtitle: String
    let deadline: String
    let deadlineColor: Color
    let date: String

    var body: some View {
        HStack(spacing: 12) {
            VStack {
                Image(systemName: icon)
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(iconColor)
            }
            .frame(width: 56, height: 56)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 1)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundStyle(.black.opacity(0.85))

                Text(subtitle)
                    .font(.system(size: 11))
                    .foregroundStyle(.black.opacity(0.5))
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 2) {
                Text(deadline)
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(deadlineColor)

                Text(date)
                    .font(.system(size: 9))
                    .foregroundStyle(.black.opacity(0.35))
            }
        }
        .padding(12)
        .background(backgroundColor)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(borderColor, lineWidth: 1)
        )
    }
}

struct TabBarItem: View {
    let icon: String
    let label: String
    let isActive: Bool

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 18))

            Text(label)
                .font(.system(size: 8, weight: .bold))
                .tracking(0.3)
        }
        .foregroundStyle(isActive ? Color(red: 1, green: 0.49, blue: 0.37) : .gray.opacity(0.4))
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    HomeStudentDashboardView()
}
