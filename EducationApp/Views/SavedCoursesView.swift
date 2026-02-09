import SwiftUI

struct SavedCoursesView: View {
    @StateObject private var persistenceManager = DataPersistenceManager.shared
    @State private var enrolledCourses: [CourseProgress] = []
    var body: some View {
            ZStack {
                Color(red: 0.97, green: 0.98, blue: 0.99).ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // 헤더
                    HStack {
                        Text("Learning Analytics")
                            .font(.system(size: 28, weight: .bold))
                        Spacer()
                        Image(systemName: "chart.bar.xaxis")
                            .font(.title2)
                            .foregroundStyle(.blue)
                    }
                    .padding(20)
                    
                    ScrollView {
                        VStack(spacing: 20) {
                            HStack(spacing: 20) {
                                AnalyticsItem(value: "\(enrolledCourses.count)", label: "Courses", icon: "book.fill", color: .blue)
                                AnalyticsItem(value: "\(persistenceManager.getCompletedLessonsCount())", label: "Lessons", icon: "play.circle.fill", color: .green)
                                AnalyticsItem(value: "3d", label: "Streak", icon: "flame.fill", color: .orange)
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(20)
                            .shadow(color: Color.black.opacity(0.05), radius: 5)
                            .padding(.horizontal)
                            
                            // 상세 리스트
                            VStack(alignment: .leading, spacing: 15) {
                                Text("Course Progress").font(.headline).padding(.horizontal)
                                
                                ForEach(enrolledCourses) { course in
                                    HStack {
                                        VStack(alignment: .leading) {
                                            Text(course.courseName).font(.subheadline.weight(.semibold))
                                            ProgressView(value: course.completionPercentage, total: 100).tint(.blue)
                                        }
                                        Text("\(Int(course.completionPercentage))%").font(.caption.weight(.bold)).foregroundStyle(.gray)
                                    }
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(16)
                                    .padding(.horizontal)
                                }
                            }
                        }
                    }
                }
            }
            .onAppear { enrolledCourses = persistenceManager.getAllCourseProgress() }
        }
}

struct AnalyticsItem: View {
    let value: String, label: String, icon: String, color: Color
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon).font(.title2).foregroundStyle(color)
            Text(value).font(.title3.weight(.bold))
            Text(label).font(.caption).foregroundStyle(.gray)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    SavedCoursesView()
}
