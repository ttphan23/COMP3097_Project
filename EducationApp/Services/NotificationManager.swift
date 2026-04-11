import Foundation
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()

    private init() {}

    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, _ in
            if granted {
                DispatchQueue.main.async {
                    self.scheduleAllPendingReminders()
                }
            }
        }
    }

    func scheduleAssignmentReminder(for assignment: Assignment) {
        let id = assignment.id
        let title = assignment.title
        let courseName = assignment.courseName
        let dueDate = assignment.dueDate
        let isCompleted = assignment.isCompleted

        let center = UNUserNotificationCenter.current()

        // Remove any existing notification for this assignment
        center.removePendingNotificationRequests(withIdentifiers: [id])

        // Don't schedule if already completed or past due
        guard !isCompleted, dueDate > Date() else { return }

        let content = UNMutableNotificationContent()
        content.title = "Assignment Due Soon"
        content.body = "\"\(title)\" for \(courseName) is due soon!"
        content.sound = .default

        // Schedule reminder 1 hour before due date
        let reminderDate = dueDate.addingTimeInterval(-3600)
        guard reminderDate > Date() else { return }

        let components = Calendar.current.dateComponents(
            [.year, .month, .day, .hour, .minute],
            from: reminderDate
        )
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)

        let request = UNNotificationRequest(
            identifier: id,
            content: content,
            trigger: trigger
        )

        center.add(request)
    }

    func scheduleAllPendingReminders() {
        let assignments = DataPersistenceManager.shared.getPendingAssignments()
        for assignment in assignments {
            scheduleAssignmentReminder(for: assignment)
        }
    }

    func cancelReminder(for assignmentId: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [assignmentId])
    }

    func cancelAllReminders() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}
