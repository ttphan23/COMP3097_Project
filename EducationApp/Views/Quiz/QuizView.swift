import SwiftUI

struct QuizView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedAnswer: Int? = nil
    @State private var currentQuestionIndex = 0
    @State private var showFeedback = false
    @State private var isCorrect = false
    
    let questions = [
        QuizQuestion(
            text: "Which psychologist is best known for developing the hierarchy of needs?",
            options: ["Sigmund Freud", "B.F. Skinner", "Abraham Maslow", "Carl Jung"],
            correctIndex: 2,
            explanation: "Maslow's hierarchy of needs is a motivational theory comprising a five-tier model of human needs."
        ),
        QuizQuestion(
            text: "What is the primary function of the hippocampus?",
            options: ["Motor Control", "Memory Formation", "Visual Processing", "Heart Rate"],
            correctIndex: 1,
            explanation: "The hippocampus is a major component of the brain and plays a critical role in memory consolidation."
        )
    ]
    
    var body: some View {
        ZStack {
            Color(red: 0.98, green: 0.98, blue: 0.99).ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(.gray)
                            .padding(12)
                            .background(Circle().fill(Color.white))
                    }
                    Spacer()
                    Text("PSYCHOLOGY 101")
                        .font(.system(size: 10, weight: .bold))
                        .tracking(1.0)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(20)
                        .foregroundStyle(.blue)
                    Spacer()
                    Image(systemName: "graduationcap.fill")
                        .foregroundStyle(.blue)
                }
                .padding()
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("QUESTION \(currentQuestionIndex + 1) OF \(questions.count)")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundStyle(.gray)
                        Spacer()
                        Text("ON FIRE! 🔥")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundStyle(.orange)
                    }
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            Capsule().fill(Color.gray.opacity(0.2)).frame(height: 6)
                            Capsule()
                                .fill(Color.green)
                                .frame(width: geometry.size.width * (CGFloat(currentQuestionIndex + 1) / CGFloat(questions.count)), height: 6)
                        }
                    }
                    .frame(height: 6)
                }
                .padding(.horizontal)
                .padding(.bottom, 30)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        Text(questions[currentQuestionIndex].text)
                            .font(.system(size: 24, weight: .bold))
                            .foregroundStyle(.black.opacity(0.85))
                            .padding(.horizontal)
                        
                        VStack(spacing: 16) {
                            ForEach(0..<questions[currentQuestionIndex].options.count, id: \.self) { index in
                                Button(action: {
                                    if selectedAnswer == nil {
                                        selectedAnswer = index
                                        checkAnswer(index)
                                    }
                                }) {
                                    HStack {
                                        ZStack {
                                            Circle()
                                                .stroke(getBorderColor(for: index), lineWidth: 2)
                                                .frame(width: 24, height: 24)
                                            if selectedAnswer == index {
                                                Circle()
                                                    .fill(getBorderColor(for: index))
                                                    .frame(width: 14, height: 14)
                                            }
                                        }
                                        Text(questions[currentQuestionIndex].options[index])
                                            .font(.system(size: 16, weight: .medium))
                                            .foregroundStyle(.black.opacity(0.8))
                                        Spacer()
                                        if showFeedback && index == questions[currentQuestionIndex].correctIndex {
                                            Image(systemName: "checkmark.circle.fill")
                                                .foregroundStyle(.green)
                                        }
                                    }
                                    .padding()
                                    .background(getBackgroundColor(for: index))
                                    .cornerRadius(16)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(getBorderColor(for: index).opacity(0.3), lineWidth: 1)
                                    )
                                }
                                .disabled(showFeedback)
                            }
                        }
                        .padding(.horizontal)
                        
                        if showFeedback {
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Image(systemName: isCorrect ? "face.smiling.fill" : "exclamationmark.circle.fill")
                                        .foregroundStyle(isCorrect ? .green : .red)
                                    Text(isCorrect ? "Correct!" : "Incorrect")
                                        .font(.headline)
                                        .foregroundStyle(isCorrect ? .green : .red)
                                }
                                Text(questions[currentQuestionIndex].explanation)
                                    .font(.subheadline)
                                    .foregroundStyle(.gray)
                                
                                Button(action: nextQuestion) {
                                    Text(currentQuestionIndex < questions.count - 1 ? "NEXT QUESTION" : "FINISH QUIZ")
                                        .font(.system(size: 14, weight: .bold))
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color(red: 1, green: 0.84, blue: 0.28))
                                        .foregroundStyle(.black)
                                        .cornerRadius(12)
                                }
                                .padding(.top, 8)
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(20)
                            .shadow(radius: 5)
                            .padding(.horizontal)
                        }
                    }
                }
            }
        }
    }
    
    func checkAnswer(_ index: Int) {
        let correct = questions[currentQuestionIndex].correctIndex
        isCorrect = (index == correct)
        withAnimation { showFeedback = true }
    }
    
    func nextQuestion() {
        if currentQuestionIndex < questions.count - 1 {
            currentQuestionIndex += 1
            selectedAnswer = nil
            showFeedback = false
        } else {
            dismiss()
        }
    }
    
    func getBorderColor(for index: Int) -> Color {
        guard let selected = selectedAnswer else { return Color.gray.opacity(0.3) }
        if index == questions[currentQuestionIndex].correctIndex { return .green }
        if index == selected { return .red }
        return Color.gray.opacity(0.3)
    }
    
    func getBackgroundColor(for index: Int) -> Color {
        guard let selected = selectedAnswer else { return Color.white }
        if index == questions[currentQuestionIndex].correctIndex { return Color.green.opacity(0.1) }
        if index == selected { return Color.red.opacity(0.1) }
        return Color.white
    }
}

struct QuizQuestion {
    let text: String
    let options: [String]
    let correctIndex: Int
    let explanation: String
}
