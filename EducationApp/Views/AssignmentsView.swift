import SwiftUI

struct AssignmentsView: View {
    @State private var selectedFilter: String = "Upcoming"
    let filters = ["Upcoming", "Completed", "Missed"]
    
    var body: some View {
        ZStack {
            Color(red: 0.97, green: 0.98, blue: 0.99).ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Text("Your Assignments")
                        .font(.system(size: 28, weight: .bold))
                    Spacer()
                    Image(systemName: "calendar")
                        .font(.title2)
                        .foregroundStyle(.blue)
                }
                .padding(20)
                
                HStack(spacing: 12) {
                    ForEach(filters, id: \.self) { filter in
                        Button(action: { selectedFilter = filter }) {
                            Text(filter)
                                .font(.system(size: 14, weight: .bold))
                                .padding(.vertical, 8)
                                .padding(.horizontal, 16)
                                .background(selectedFilter == filter ? Color.blue : Color.white)
                                .foregroundStyle(selectedFilter == filter ? .white : .gray)
                                .cornerRadius(20)
                                .shadow(radius: 1)
                        }
                    }
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
                
                ScrollView {
                    VStack(spacing: 16) {
                        AssignmentRow(courseCode: "CS101", courseName: "Data Structures", taskName: "Binary Search Tree", deadline: "11:59 PM", tag: "Math", tagColor: .blue, isCompleted: false, isPriority: true)
                        AssignmentRow(courseCode: "ENG202", courseName: "Research", taskName: "AI Ethics Essay", deadline: "Submitted", tag: "Humanities", tagColor: .pink, isCompleted: true, isPriority: false)
                        AssignmentRow(courseCode: "BIO305", courseName: "Lab Report", taskName: "Cellular Respiration", deadline: "Tomorrow", tag: "Science", tagColor: .green, isCompleted: false, isPriority: false)
                    }
                    .padding(.bottom, 100)
                }
            }
        }
    }
}

struct AssignmentRow: View {
    let courseCode: String, courseName: String, taskName: String, deadline: String, tag: String, tagColor: Color, isCompleted: Bool, isPriority: Bool
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: isCompleted ? "checkmark.circle.fill" : "circle")
                .font(.title2)
                .foregroundStyle(isCompleted ? .green : .gray.opacity(0.3))
            
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text("\(courseCode): \(courseName)").font(.caption.weight(.bold)).foregroundStyle(.gray)
                    Spacer()
                    Text(tag).font(.caption.weight(.bold)).foregroundStyle(tagColor).padding(4).background(tagColor.opacity(0.1)).cornerRadius(4)
                }
                Text(taskName).font(.headline)
                HStack {
                    Image(systemName: "clock").font(.caption)
                    Text(deadline).font(.caption)
                    if isPriority {
                        Text("High Priority").font(.caption.weight(.bold)).foregroundStyle(.orange)
                    }
                }
                .foregroundStyle(.gray)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        .padding(.horizontal, 20)
        .opacity(isCompleted ? 0.6 : 1.0)
    }
}
