import SwiftUI

struct NotificationsView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            HStack {
                Button(action: { dismiss() }) { Image(systemName: "xmark").padding() }
                Spacer()
                Text("Notifications").font(.headline)
                Spacer()
                Color.clear.frame(width: 44)
            }
            List {
                NotificationRow(title: "Grade Posted", desc: "You got an A in Biology!", time: "10m ago", icon: "graduationcap.fill", color: .green)
                NotificationRow(title: "Assignment Due", desc: "History Essay due in 2 hours.", time: "2h ago", icon: "exclamationmark.circle.fill", color: .orange)
                NotificationRow(title: "Club Meeting", desc: "Art Club meets at 4 PM.", time: "1d ago", icon: "person.3.fill", color: .purple)
            }
            .listStyle(.plain)
        }
    }
}

struct NotificationRow: View {
    let title: String, desc: String, time: String, icon: String, color: Color
    var body: some View {
        HStack(alignment: .top) {
            Image(systemName: icon).foregroundStyle(color).font(.title2).padding(8).background(color.opacity(0.1)).clipShape(Circle())
            VStack(alignment: .leading) {
                Text(title).font(.headline)
                Text(desc).font(.subheadline).foregroundStyle(.gray)
            }
            Spacer()
            Text(time).font(.caption).foregroundStyle(.gray)
        }
        .padding(.vertical, 4)
    }
}
