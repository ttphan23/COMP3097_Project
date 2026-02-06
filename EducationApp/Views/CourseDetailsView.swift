import SwiftUI

struct CourseDetailsView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            VStack(spacing: 0) {
                // Sticky Navigation Bar
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.gray.opacity(0.6))
                            .frame(width: 40, height: 40)
                            .background(Circle().fill(Color.gray.opacity(0.05)))
                    }

                    Spacer()

                    Text("Syllabus Overview")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(.gray.opacity(0.8))

                    Spacer()

                    Button(action: {}) {
                        Image(systemName: "bookmark")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.gray.opacity(0.6))
                            .frame(width: 40, height: 40)
                    }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color.white.opacity(0.9))
                .overlay(alignment: .bottom) {
                    Divider()
                }

                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 0) {
                        // Hero Image Section
                        ZStack(alignment: .bottomLeading) {
                            Image(systemName: "book.circle.fill")
                                .font(.system(size: 200))
                                .foregroundStyle(Color.blue.opacity(0.1))
                                .frame(maxWidth: .infinity, alignment: .trailing)

                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.black.opacity(0.8),
                                    Color.black.opacity(0.2),
                                    Color.clear
                                ]),
                                startPoint: .bottom,
                                endPoint: .top
                            )

                            VStack(alignment: .leading, spacing: 12) {
                                HStack(spacing: 8) {
                                    Image(systemName: "checkmark.seal.fill")
                                        .font(.system(size: 10))
                                        .foregroundStyle(Color(red: 1, green: 0.84, blue: 0))

                                    Text(".EDU VERIFIED COURSE")
                                        .font(.system(size: 9, weight: .bold))
                                        .tracking(0.8)
                                        .foregroundStyle(.white)
                                }
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color.white.opacity(0.2))
                                .cornerRadius(12)

                                Text("Introduction to Psychology")
                                    .font(.system(size: 28, weight: .bold, design: .default))
                                    .foregroundStyle(.white)
                                    .lineLimit(3)
                            }
                            .padding(20)
                        }
                        .frame(height: 280)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(32)
                        .padding(20)

                        // Stats Section
                        HStack(spacing: 0) {
                            VStack(spacing: 6) {
                                HStack(spacing: 6) {
                                    Image(systemName: "star.fill")
                                        .font(.system(size: 12))
                                        .foregroundStyle(Color(red: 1, green: 0.84, blue: 0))

                                    Text("4.9")
                                        .font(.system(size: 13, weight: .bold))
                                        .foregroundStyle(.black.opacity(0.9))

                                    Text("(2k reviews)")
                                        .font(.system(size: 11))
                                        .foregroundStyle(.gray.opacity(0.5))
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)

                            Divider()
                                .frame(height: 16)

                            VStack(spacing: 6) {
                                HStack(spacing: 6) {
                                    Image(systemName: "person.2.fill")
                                        .font(.system(size: 12))
                                        .foregroundStyle(.gray.opacity(0.5))

                                    Text("12k Students")
                                        .font(.system(size: 13, weight: .semibold))
                                        .foregroundStyle(.black.opacity(0.85))
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .center)

                            Divider()
                                .frame(height: 16)

                            VStack(spacing: 6) {
                                HStack(spacing: 6) {
                                    Image(systemName: "clock.fill")
                                        .font(.system(size: 12))
                                        .foregroundStyle(.gray.opacity(0.5))

                                    Text("18h Total")
                                        .font(.system(size: 13, weight: .semibold))
                                        .foregroundStyle(.black.opacity(0.85))
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        .background(Color.blue.opacity(0.03))
                        .overlay(
                            VStack {
                                Divider()
                                Spacer()
                                Divider()
                            }
                        )
                        .padding(.bottom, 12)

                        // Instructor Section
                        HStack(spacing: 12) {
                            Image(systemName: "person.crop.circle.fill")
                                .font(.system(size: 48))
                                .foregroundStyle(Color.blue.opacity(0.3))
                                .frame(width: 56, height: 56)
                                .background(RoundedRectangle(cornerRadius: 16).fill(Color.gray.opacity(0.1)))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color.white, lineWidth: 4)
                                )
                                .shadow(radius: 4)

                            VStack(alignment: .leading, spacing: 2) {
                                Text("INSTRUCTOR")
                                    .font(.system(size: 9, weight: .bold))
                                    .tracking(0.5)
                                    .foregroundStyle(Color(red: 0.176, green: 0.357, blue: 0.94))

                                Text("Dr. Sarah Jenkins")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundStyle(.black.opacity(0.9))

                                Text("Dept. of Behavioral Sciences")
                                    .font(.system(size: 11))
                                    .foregroundStyle(.gray.opacity(0.55))
                            }

                            Spacer()

                            Button(action: {}) {
                                Text("Profile")
                                    .font(.system(size: 11, weight: .bold))
                                    .foregroundStyle(.black.opacity(0.8))
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .background(RoundedRectangle(cornerRadius: 12).fill(Color.white))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.gray.opacity(0.15), lineWidth: 1)
                                    )
                                    .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                            }
                        }
                        .padding(16)
                        .background(Color.gray.opacity(0.03))
                        .cornerRadius(20)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 24)

                        // Key Objectives Section
                        VStack(alignment: .leading, spacing: 16) {
                            HStack(spacing: 8) {
                                Circle()
                                    .fill(Color(red: 0.176, green: 0.357, blue: 0.94))
                                    .frame(width: 8, height: 8)

                                Text("Key Objectives")
                                    .font(.system(size: 18, weight: .bold, design: .default))
                                    .foregroundStyle(.black.opacity(0.9))
                            }

                            VStack(alignment: .leading, spacing: 16) {
                                ObjectiveItem(
                                    text: "Master the foundational principles of neuroscience and how they relate to everyday human behavior."
                                )

                                ObjectiveItem(
                                    text: "Develop critical thinking skills to evaluate psychological research and data across diverse cultures."
                                )
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 28)

                        // Course Modules Section
                        VStack(alignment: .leading, spacing: 16) {
                            HStack(alignment: .top, spacing: 16) {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Course Modules")
                                        .font(.system(size: 18, weight: .bold, design: .default))
                                        .foregroundStyle(.black.opacity(0.9))

                                    Text("12 Lessons • 3 Assignments")
                                        .font(.system(size: 11))
                                        .foregroundStyle(.gray.opacity(0.4))
                                }

                                Spacer()

                                VStack(alignment: .trailing, spacing: 6) {
                                    Text("35% Done")
                                        .font(.system(size: 12, weight: .bold))
                                        .foregroundStyle(Color(red: 0.176, green: 0.357, blue: 0.94))

                                    ZStack(alignment: .leading) {
                                        RoundedRectangle(cornerRadius: 2)
                                            .fill(Color.gray.opacity(0.1))

                                        RoundedRectangle(cornerRadius: 2)
                                            .fill(Color(red: 0.176, green: 0.357, blue: 0.94))
                                            .frame(width: 28.8, alignment: .leading)
                                    }
                                    .frame(width: 82, height: 6)
                                }
                            }

                            VStack(spacing: 12) {
                                // Completed Module - Navigable
                                NavigationLink(destination: LessonView().navigationBarHidden(true)) {
                                    CourseModuleCard(
                                        icon: "checkmark.circle.fill",
                                        iconColor: Color.green,
                                        backgroundColor: Color.blue.opacity(0.03),
                                        borderColor: Color.gray.opacity(0.1),
                                        title: "1. Foundations of Behavior",
                                        subtitle: "12 mins",
                                        isCompleted: true,
                                        isCurrent: false,
                                        isLocked: false
                                    )
                                }

                                // Current Module - Navigable
                                NavigationLink(destination: LessonView().navigationBarHidden(true)) {
                                    CourseModuleCard(
                                        icon: "play.fill",
                                        iconColor: Color.white,
                                        backgroundColor: Color(red: 0.176, green: 0.357, blue: 0.94).opacity(0.08),
                                        borderColor: Color(red: 0.176, green: 0.357, blue: 0.94).opacity(0.2),
                                        title: "2. Cognitive Processes",
                                        subtitle: "Current Module",
                                        isCompleted: false,
                                        isCurrent: true,
                                        isLocked: false
                                    )
                                }

                                // Locked Module
                                CourseModuleCard(
                                    icon: "lock.fill",
                                    iconColor: Color.gray.opacity(0.3),
                                    backgroundColor: Color.gray.opacity(0.03),
                                    borderColor: Color.gray.opacity(0.1),
                                    title: "3. Social Psychology",
                                    subtitle: "Quiz • 15 mins",
                                    isCompleted: false,
                                    isCurrent: false,
                                    isLocked: true
                                )
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 140)
                    }
                }
            }

            // Fixed Bottom Button
            VStack(spacing: 0) {
                Spacer()

                VStack(spacing: 14) {
                    NavigationLink(destination: LessonView().navigationBarHidden(true)) {
                        HStack(spacing: 12) {
                            Text("Resume Learning")
                                .font(.system(size: 16, weight: .heavy))
                                .foregroundStyle(.white)

                            Image(systemName: "arrow.forward")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(.white)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(Color(red: 0.176, green: 0.357, blue: 0.94))
                        .cornerRadius(20)
                        .shadow(color: Color(red: 0.176, green: 0.357, blue: 0.94).opacity(0.4), radius: 12, x: 0, y: 6)
                    }

                    HStack(spacing: 6) {
                        Image(systemName: "checkmark.seal.fill")
                            .font(.system(size: 10))
                            .foregroundStyle(.gray.opacity(0.4))

                        Text("VERIFIED .EDU ACCESS ONLY")
                            .font(.system(size: 9, weight: .bold))
                            .tracking(0.5)
                            .foregroundStyle(.gray.opacity(0.4))
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 20)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.white.opacity(0.9),
                            Color.white.opacity(0.95),
                            Color.white
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .overlay(alignment: .top) {
                    Divider()
                }
            }
        }
    }
}

struct ObjectiveItem: View {
    let text: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Circle()
                .fill(Color(red: 0.176, green: 0.357, blue: 0.94))
                .frame(width: 8, height: 8)
                .padding(.top, 6)

            Text(text)
                .font(.system(size: 15))
                .foregroundStyle(.gray.opacity(0.7))
                .lineSpacing(1.2)

            Spacer()
        }
    }
}

struct CourseModuleCard: View {
    let icon: String
    let iconColor: Color
    let backgroundColor: Color
    let borderColor: Color
    let title: String
    let subtitle: String
    let isCompleted: Bool
    let isCurrent: Bool
    let isLocked: Bool

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                if isCurrent {
                    Circle()
                        .fill(Color(red: 0.176, green: 0.357, blue: 0.94))
                        .shadow(color: Color(red: 0.176, green: 0.357, blue: 0.94).opacity(0.3), radius: 6, x: 0, y: 3)
                } else if isCompleted {
                    Circle()
                        .fill(Color.green.opacity(0.2))
                } else {
                    Circle()
                        .fill(Color.gray.opacity(0.1))
                        .opacity(isLocked ? 0.6 : 1)
                }

                Image(systemName: icon)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(isCurrent ? Color.white : iconColor)
            }
            .frame(width: 40, height: 40)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 13, weight: .bold))
                    .foregroundStyle(isLocked ? .gray.opacity(0.5) : .black.opacity(0.9))

                Text(subtitle)
                    .font(.system(size: 9))
                    .foregroundStyle(isCurrent ? Color(red: 0.176, green: 0.357, blue: 0.94) : .gray.opacity(0.4))
                    .fontWeight(isCurrent ? .bold : .regular)
                    .tracking(isCurrent ? 0.3 : 0)
            }

            Spacer()

            if isCurrent {
                Image(systemName: "mic.fill")
                    .font(.system(size: 12))
                    .foregroundStyle(Color(red: 0.176, green: 0.357, blue: 0.94))
            } else {
                Image(systemName: "ellipsis")
                    .font(.system(size: 14))
                    .foregroundStyle(.gray.opacity(0.3))
            }
        }
        .padding(12)
        .background(backgroundColor)
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(borderColor, lineWidth: isLocked ? 1 : 2)
        )
        .opacity(isLocked ? 0.6 : 1)
    }
}

#Preview {
    NavigationStack {
        CourseDetailsView()
    }
}
