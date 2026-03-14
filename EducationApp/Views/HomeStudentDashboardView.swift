import SwiftUI

struct HomeStudentDashboardView: View {
    @StateObject private var persistenceManager = DataPersistenceManager.shared
    @State private var stats = (totalCoursesEnrolled: 0, totalCoursesCompleted: 0, totalLessonsCompleted: 0, averageProgress: 0.0)
    @State private var showNotifications: Bool = false
    @State private var showAddAssignment: Bool = false
    @Binding var selectedTab: Int

    var mostRecentCourse: (course: Course, progress: CourseProgress)? {
        let courseProgressList = persistenceManager.getAllCourseProgress()
        guard let latest = courseProgressList
            .sorted(by: { ($0.lastAccessedDate ?? $0.enrollmentDate) > ($1.lastAccessedDate ?? $1.enrollmentDate) })
            .first,
              let course = CourseStore.sampleCourses.first(where: { $0.id == latest.courseId })
        else { return nil }
        return (course, latest)
    }

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
                        Text(persistenceManager.currentUser?.university.uppercased() ?? "EDUVANTAGE")
                            .font(.system(size: 9, weight: .bold))
                            .tracking(0.5)
                            .foregroundStyle(Color(red: 1, green: 0.49, blue: 0.37))

                        Text("Home")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundStyle(.black.opacity(0.9))
                    }

                    Spacer()

                    Button(action: { showNotifications = true }) {
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
                            let firstName = persistenceManager.currentUser?.name.components(separatedBy: " ").first ?? "Student"
                            Text("Hi, \(firstName)! 👋")
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
                            let progressValue = stats.averageProgress / 100.0
                            let progressPercent = Int(stats.averageProgress)
                            HStack(spacing: 16) {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Your Week")
                                        .font(.system(size: 18, weight: .bold, design: .rounded))
                                        .foregroundStyle(.black.opacity(0.9))

                                    Text("\(progressPercent)% of your target reached")
                                        .font(.system(size: 13))
                                        .foregroundStyle(.black.opacity(0.5))

                                    HStack(spacing: 8) {
                                        Image(systemName: progressPercent > 50 ? "party.popper.fill" : "flame.fill")
                                            .font(.system(size: 14))
                                        Text(progressPercent > 50 ? "Keep it up!" : "Let's go!")
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
                                        .trim(from: 0, to: max(progressValue, 0.01))
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
                                        Text("\(progressPercent)%")
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
                                    selectedTab = 1
                                }
                                .font(.system(size: 13, weight: .bold))
                                .foregroundStyle(Color(red: 1, green: 0.49, blue: 0.37))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color(red: 1, green: 0.9, blue: 0.95).opacity(0.5))
                                .cornerRadius(12)
                            }
                            .padding(.horizontal, 18)

                            if let recent = mostRecentCourse {
                                let progressPct = Int(recent.progress.completionPercentage)
                                let catColor = colorForCategory(recent.progress.category)

                                VStack(spacing: 0) {
                                    ZStack(alignment: .topLeading) {
                                        Image(systemName: "book.circle.fill")
                                            .font(.system(size: 120))
                                            .foregroundStyle(catColor.opacity(0.15))
                                            .frame(maxWidth: .infinity, maxHeight: 140, alignment: .bottomTrailing)
                                            .offset(x: 20, y: -20)

                                        VStack(alignment: .leading, spacing: 8) {
                                            HStack(spacing: 6) {
                                                Image(systemName: "book.fill")
                                                    .font(.system(size: 11))
                                                    .foregroundStyle(catColor)

                                                Text(recent.progress.category.uppercased())
                                                    .font(.system(size: 9, weight: .bold))
                                                    .tracking(0.5)
                                                    .foregroundStyle(catColor)
                                            }
                                            .padding(.horizontal, 10)
                                            .padding(.vertical, 4)
                                            .background(Color.white.opacity(0.85))
                                            .cornerRadius(12)
                                        }
                                        .padding(12)
                                    }
                                    .frame(height: 140)
                                    .background(catColor.opacity(0.08))

                                    VStack(alignment: .leading, spacing: 12) {
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(recent.course.title)
                                                .font(.system(size: 16, weight: .bold, design: .rounded))
                                                .foregroundStyle(.black.opacity(0.9))

                                            Text("\(recent.progress.lessonsCompleted)/\(recent.progress.totalLessons) lessons completed")
                                                .font(.system(size: 12))
                                                .foregroundStyle(.black.opacity(0.5))
                                        }

                                        // Progress Bar
                                        VStack(spacing: 8) {
                                            GeometryReader { geo in
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
                                                        .frame(width: geo.size.width * CGFloat(recent.progress.completionPercentage / 100.0))
                                                }
                                            }
                                            .frame(height: 8)

                                            HStack {
                                                Text("\(progressPct)% Done")
                                                    .font(.system(size: 12, weight: .bold))
                                                    .foregroundStyle(Color(red: 1, green: 0.49, blue: 0.37))

                                                Spacer()

                                                NavigationLink(destination: CourseDetailsView(course: recent.course).navigationBarHidden(true)) {
                                                    Text("Jump back in")
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
                                    }
                                    .padding(16)
                                    .background(Color.white)
                                }
                                .cornerRadius(16)
                                .padding(.horizontal, 18)
                                .shadow(color: Color.black.opacity(0.05), radius: 12, x: 0, y: 4)
                            } else {
                                // No enrolled courses
                                VStack(spacing: 12) {
                                    Image(systemName: "books.vertical.fill")
                                        .font(.system(size: 36))
                                        .foregroundStyle(.gray.opacity(0.3))
                                    Text("No courses yet")
                                        .font(.system(size: 15, weight: .semibold))
                                        .foregroundStyle(.gray.opacity(0.6))
                                    Button("Browse Catalog") {
                                        selectedTab = 1
                                    }
                                    .font(.system(size: 13, weight: .bold))
                                    .foregroundStyle(.white)
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 10)
                                    .background(Color(red: 1, green: 0.49, blue: 0.37))
                                    .cornerRadius(12)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(24)
                                .background(Color.white)
                                .cornerRadius(16)
                                .padding(.horizontal, 18)
                                .shadow(color: Color.black.opacity(0.05), radius: 12, x: 0, y: 4)
                            }
                        }

                        // Don't Forget Section - Dynamic Assignments
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("Don't Forget! ✏️")
                                    .font(.system(size: 22, weight: .bold, design: .rounded))
                                    .foregroundStyle(.black.opacity(0.9))

                                Spacer()

                                Button(action: { showAddAssignment = true }) {
                                    Image(systemName: "plus.circle.fill")
                                        .font(.system(size: 22))
                                        .foregroundStyle(Color(red: 1, green: 0.49, blue: 0.37))
                                }
                            }
                            .padding(.horizontal, 18)

                            let pendingAssignments = persistenceManager.getPendingAssignments()

                            if pendingAssignments.isEmpty {
                                VStack(spacing: 8) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.system(size: 32))
                                        .foregroundStyle(Color.green.opacity(0.4))
                                    Text("All caught up!")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundStyle(.gray.opacity(0.6))
                                }
                                .frame(maxWidth: .infinity)
                                .padding(20)
                                .background(Color.green.opacity(0.05))
                                .cornerRadius(12)
                                .padding(.horizontal, 18)
                            } else {
                                VStack(spacing: 12) {
                                    ForEach(pendingAssignments) { assignment in
                                        DynamicAssignmentCard(
                                            assignment: assignment,
                                            onComplete: {
                                                persistenceManager.toggleAssignmentCompleted(id: assignment.id)
                                            },
                                            onDelete: {
                                                persistenceManager.deleteAssignment(id: assignment.id)
                                            }
                                        )
                                    }
                                }
                                .padding(.horizontal, 18)
                            }
                        }

                        // University Member Badge
                        VStack {
                            HStack(spacing: 8) {
                                Image(systemName: "checkmark.seal.fill")
                                    .font(.system(size: 16))
                                    .foregroundStyle(Color.green)

                                Text("\(persistenceManager.currentUser?.university.uppercased() ?? "EDU") MEMBER")
                                    .font(.system(size: 10, weight: .bold))
                                    .tracking(0.3)
                                    .foregroundStyle(Color(red: 0.1, green: 0.55, blue: 0.1))
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(Color(red: 0.86, green: 0.99, blue: 0.84).opacity(0.5))
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.green.opacity(0.2), lineWidth: 1)
                            )
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 18)
                        .padding(.vertical, 12)

                        Spacer(minLength: 20)
                    }
                }

                Spacer(minLength: 0)
            }
        }
        .onAppear {
            stats = persistenceManager.getAppStatistics()
            persistenceManager.seedDefaultAssignments()
        }
        .sheet(isPresented: $showNotifications) {
            NotificationsSheet()
        }
        .sheet(isPresented: $showAddAssignment) {
            AddAssignmentSheet(persistenceManager: persistenceManager)
        }
    }
}

// MARK: - Dynamic Assignment Card

struct DynamicAssignmentCard: View {
    let assignment: Assignment
    let onComplete: () -> Void
    let onDelete: () -> Void

    var deadlineText: String {
        let calendar = Calendar.current
        let now = Date()
        let diff = calendar.dateComponents([.hour, .day], from: now, to: assignment.dueDate)

        if assignment.dueDate < now {
            return "Overdue!"
        } else if let hours = diff.hour, hours < 24 {
            return "\(max(hours, 0))h Left!"
        } else if let days = diff.day, days == 0 {
            return "Today"
        } else if let days = diff.day, days == 1 {
            return "Tomorrow"
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d"
            return formatter.string(from: assignment.dueDate)
        }
    }

    var deadlineColor: Color {
        let calendar = Calendar.current
        let hours = calendar.dateComponents([.hour], from: Date(), to: assignment.dueDate).hour ?? 0
        if assignment.dueDate < Date() { return Color.red }
        if hours < 24 { return Color(red: 0.9, green: 0.4, blue: 0.5) }
        if hours < 72 { return Color.blue }
        return Color(red: 0.95, green: 0.75, blue: 0)
    }

    var iconColor: Color {
        switch assignment.icon {
        case "book.fill": return Color(red: 0.95, green: 0.5, blue: 0.7)
        case "function": return Color.blue
        case "flask.fill": return Color(red: 1, green: 0.8, blue: 0)
        default: return Color(red: 0.231, green: 0.51, blue: 0.96)
        }
    }

    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, h:mm a"
        return formatter.string(from: assignment.dueDate)
    }

    var body: some View {
        HStack(spacing: 12) {
            Button(action: onComplete) {
                Image(systemName: "circle")
                    .font(.system(size: 22))
                    .foregroundStyle(.gray.opacity(0.3))
            }

            VStack {
                Image(systemName: assignment.icon)
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(iconColor)
            }
            .frame(width: 48, height: 48)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 1)

            VStack(alignment: .leading, spacing: 2) {
                Text(assignment.title)
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundStyle(.black.opacity(0.85))

                Text(assignment.courseName)
                    .font(.system(size: 11))
                    .foregroundStyle(.black.opacity(0.5))
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 2) {
                Text(deadlineText)
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(deadlineColor)

                Text(dateString)
                    .font(.system(size: 9))
                    .foregroundStyle(.black.opacity(0.35))
            }
        }
        .padding(12)
        .background(iconColor.opacity(0.06))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(iconColor.opacity(0.15), lineWidth: 1)
        )
        .swipeActions(edge: .trailing) {
            Button(role: .destructive, action: onDelete) {
                Label("Delete", systemImage: "trash")
            }
        }
    }
}

// MARK: - Add Assignment Sheet

struct AddAssignmentSheet: View {
    @Environment(\.dismiss) private var dismiss
    let persistenceManager: DataPersistenceManager

    @State private var title: String = ""
    @State private var courseName: String = ""
    @State private var dueDate: Date = Date().addingTimeInterval(86400)
    @State private var selectedIcon: String = "doc.fill"

    let icons = ["doc.fill", "book.fill", "function", "flask.fill", "pencil", "laptopcomputer"]

    var body: some View {
        NavigationStack {
            Form {
                Section("Assignment Details") {
                    TextField("Title", text: $title)
                    TextField("Course Name", text: $courseName)
                    DatePicker("Due Date", selection: $dueDate, displayedComponents: [.date, .hourAndMinute])
                }

                Section("Icon") {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(icons, id: \.self) { icon in
                                Button(action: { selectedIcon = icon }) {
                                    Image(systemName: icon)
                                        .font(.system(size: 20))
                                        .frame(width: 44, height: 44)
                                        .background(selectedIcon == icon ? Color(red: 0.231, green: 0.51, blue: 0.96).opacity(0.15) : Color.gray.opacity(0.1))
                                        .foregroundStyle(selectedIcon == icon ? Color(red: 0.231, green: 0.51, blue: 0.96) : .gray)
                                        .cornerRadius(12)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(selectedIcon == icon ? Color(red: 0.231, green: 0.51, blue: 0.96) : Color.clear, lineWidth: 2)
                                        )
                                }
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("New Assignment")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        guard !title.isEmpty else { return }
                        let assignment = Assignment(
                            title: title,
                            courseName: courseName,
                            dueDate: dueDate,
                            icon: selectedIcon
                        )
                        persistenceManager.saveAssignment(assignment)
                        dismiss()
                    }
                    .disabled(title.isEmpty)
                }
            }
        }
    }
}

// MARK: - Notifications Sheet

struct NotificationsSheet: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var persistenceManager = DataPersistenceManager.shared

    var body: some View {
        NavigationStack {
            List {
                let pending = persistenceManager.getPendingAssignments()
                if pending.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "bell.slash.fill")
                            .font(.system(size: 40))
                            .foregroundStyle(.gray.opacity(0.3))
                        Text("No notifications")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.gray.opacity(0.6))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 40)
                    .listRowSeparator(.hidden)
                } else {
                    ForEach(pending) { assignment in
                        HStack(spacing: 12) {
                            Image(systemName: "bell.fill")
                                .font(.system(size: 14))
                                .foregroundStyle(Color(red: 1, green: 0.49, blue: 0.37))

                            VStack(alignment: .leading, spacing: 2) {
                                Text(assignment.title)
                                    .font(.system(size: 14, weight: .bold))
                                Text("Due: \(assignment.dueDate, style: .relative) from now")
                                    .font(.system(size: 12))
                                    .foregroundStyle(.gray)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Notifications")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
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
    HomeStudentDashboardView(selectedTab: .constant(0))
}
