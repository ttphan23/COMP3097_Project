import SwiftUI

<<<<<<< HEAD
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
=======
struct QuizQuestion: Identifiable {
    let id = UUID()
    let question: String
    let options: [String]
    let correctIndex: Int
}

struct QuizView: View {
    @Environment(\.dismiss) private var dismiss
    let courseName: String
    let questions: [QuizQuestion]

    @State private var currentIndex: Int = 0
    @State private var selectedAnswer: Int? = nil
    @State private var answers: [Int?] = []
    @State private var showResult: Bool = false
    @State private var score: Int = 0

    var body: some View {
        ZStack {
            Color(.systemBackground).ignoresSafeArea()

            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.gray.opacity(0.6))
                            .frame(width: 40, height: 40)
                            .background(RoundedRectangle(cornerRadius: 12).fill(Color.gray.opacity(0.1)))
                    }

                    Spacer()

                    Text("Quiz")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(Color(.label).opacity(0.8))

                    Spacer()

                    Text("\(currentIndex + 1)/\(questions.count)")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(Color(red: 0.231, green: 0.51, blue: 0.96))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(10)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)

                // Progress bar
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.gray.opacity(0.1))
                            .frame(height: 6)

                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color(red: 0.231, green: 0.51, blue: 0.96))
                            .frame(width: geo.size.width * CGFloat(currentIndex + 1) / CGFloat(questions.count), height: 6)
                    }
                }
                .frame(height: 6)
                .padding(.horizontal, 16)

                if showResult {
                    quizResultView
                } else {
                    questionView
                }
            }
        }
        .onAppear {
            answers = Array(repeating: nil, count: questions.count)
        }
    }

    var questionView: some View {
        let question = questions[currentIndex]

        return ScrollView {
            VStack(spacing: 24) {
                // Course label
                Text(courseName.uppercased())
                    .font(.system(size: 10, weight: .bold))
                    .tracking(0.5)
                    .foregroundStyle(Color(red: 0.231, green: 0.51, blue: 0.96))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(10)
                    .padding(.top, 20)

                // Question
                Text(question.question)
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundStyle(Color(.label).opacity(0.85))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)

                // Options
                VStack(spacing: 12) {
                    ForEach(Array(question.options.enumerated()), id: \.offset) { index, option in
                        Button(action: {
                            selectedAnswer = index
                            answers[currentIndex] = index
                        }) {
                            HStack(spacing: 14) {
                                ZStack {
                                    Circle()
                                        .stroke(
                                            selectedAnswer == index
                                                ? Color(red: 0.231, green: 0.51, blue: 0.96)
                                                : Color.gray.opacity(0.25),
                                            lineWidth: 2
                                        )
                                        .frame(width: 24, height: 24)

                                    if selectedAnswer == index {
                                        Circle()
                                            .fill(Color(red: 0.231, green: 0.51, blue: 0.96))
                                            .frame(width: 14, height: 14)
                                    }
                                }

                                Text(option)
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundStyle(Color(.label).opacity(0.8))
                                    .multilineTextAlignment(.leading)

                                Spacer()
                            }
                            .padding(16)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(selectedAnswer == index ? Color.blue.opacity(0.06) : Color.white)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(
                                        selectedAnswer == index
                                            ? Color(red: 0.231, green: 0.51, blue: 0.96).opacity(0.4)
                                            : Color.gray.opacity(0.12),
                                        lineWidth: selectedAnswer == index ? 2 : 1
                                    )
                            )
                        }
                    }
                }
                .padding(.horizontal, 20)

                // Next / Submit button
                Button(action: {
                    if currentIndex < questions.count - 1 {
                        currentIndex += 1
                        selectedAnswer = answers[currentIndex]
                    } else {
                        calculateScore()
                        showResult = true
                    }
                }) {
                    Text(currentIndex < questions.count - 1 ? "Next" : "Submit Quiz")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(selectedAnswer != nil ? Color(red: 0.231, green: 0.51, blue: 0.96) : Color.gray.opacity(0.3))
                        )
                }
                .disabled(selectedAnswer == nil)
                .padding(.horizontal, 20)
                .padding(.bottom, 32)
            }
        }
    }

    var quizResultView: some View {
        VStack(spacing: 24) {
            Spacer()

            ZStack {
                Circle()
                    .fill(score >= questions.count / 2 ? Color.green.opacity(0.12) : Color.orange.opacity(0.12))
                    .frame(width: 140, height: 140)

                Circle()
                    .stroke(
                        score >= questions.count / 2 ? Color.green.opacity(0.3) : Color.orange.opacity(0.3),
                        style: StrokeStyle(lineWidth: 2, dash: [6, 6])
                    )
                    .frame(width: 140, height: 140)

                VStack(spacing: 4) {
                    Text("\(score)/\(questions.count)")
                        .font(.system(size: 36, weight: .heavy, design: .rounded))
                        .foregroundStyle(score >= questions.count / 2 ? Color.green : Color.orange)

                    Text("Score")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.gray.opacity(0.6))
                }
            }

            Text(score == questions.count ? "Perfect Score!" : (score >= questions.count / 2 ? "Great Job!" : "Keep Practicing!"))
                .font(.system(size: 28, weight: .heavy, design: .rounded))
                .foregroundStyle(Color(.label).opacity(0.85))

            Text("You answered \(score) out of \(questions.count) questions correctly.")
                .font(.system(size: 15))
                .foregroundStyle(.gray.opacity(0.6))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)

            // Score breakdown
            VStack(spacing: 8) {
                ForEach(Array(questions.enumerated()), id: \.offset) { index, question in
                    let isCorrect = answers[index] == question.correctIndex
                    HStack(spacing: 12) {
                        Image(systemName: isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .foregroundStyle(isCorrect ? Color.green : Color.red)

                        Text("Q\(index + 1)")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundStyle(Color(.label).opacity(0.7))

                        Spacer()

                        Text(isCorrect ? "Correct" : "Incorrect")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundStyle(isCorrect ? Color.green : Color.red)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(isCorrect ? Color.green.opacity(0.05) : Color.red.opacity(0.05))
                    .cornerRadius(10)
                }
            }
            .padding(.horizontal, 20)

            VStack(spacing: 12) {
                Button(action: {
                    currentIndex = 0
                    selectedAnswer = nil
                    answers = Array(repeating: nil, count: questions.count)
                    score = 0
                    showResult = false
                }) {
                    Text("Retake Quiz")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundStyle(Color(red: 0.231, green: 0.51, blue: 0.96))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(RoundedRectangle(cornerRadius: 16).fill(Color.blue.opacity(0.1)))
                }

                Button(action: { dismiss() }) {
                    Text("Done")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(RoundedRectangle(cornerRadius: 16).fill(Color(red: 0.231, green: 0.51, blue: 0.96)))
                }
            }
            .padding(.horizontal, 20)

            Spacer()
        }
    }

    private func calculateScore() {
        score = 0
        for (index, question) in questions.enumerated() {
            if answers[index] == question.correctIndex {
                score += 1
            }
        }
    }
}

// MARK: - Quiz Data per Course

struct CourseQuizStore {
    static func questions(for courseId: String) -> [QuizQuestion] {
        switch courseId {
        case "course_quantum_physics_101":
            return [
                QuizQuestion(question: "What is wave-particle duality?", options: ["Light is only a wave", "Light is only a particle", "Light exhibits both wave and particle properties", "Light has no measurable properties"], correctIndex: 2),
                QuizQuestion(question: "Who proposed the uncertainty principle?", options: ["Einstein", "Bohr", "Heisenberg", "Schrödinger"], correctIndex: 2),
                QuizQuestion(question: "What does Schrödinger's equation describe?", options: ["Classical motion", "Quantum state evolution over time", "Electromagnetic fields", "Nuclear decay rates"], correctIndex: 1),
            ]

        case "course_modern_art_history":
            return [
                QuizQuestion(question: "Which movement is Claude Monet associated with?", options: ["Cubism", "Impressionism", "Surrealism", "Pop Art"], correctIndex: 1),
                QuizQuestion(question: "Who is known as the father of Pop Art?", options: ["Picasso", "Dalí", "Andy Warhol", "Monet"], correctIndex: 2),
                QuizQuestion(question: "Abstract Expressionism originated in which country?", options: ["France", "Italy", "United States", "Germany"], correctIndex: 2),
            ]

        case "course_algorithm_design":
            return [
                QuizQuestion(question: "What does Big-O notation measure?", options: ["Code readability", "Worst-case time complexity", "Memory usage only", "Number of variables"], correctIndex: 1),
                QuizQuestion(question: "Which sorting algorithm has O(n log n) average case?", options: ["Bubble Sort", "Selection Sort", "Merge Sort", "Insertion Sort"], correctIndex: 2),
                QuizQuestion(question: "Dynamic programming is best for problems with:", options: ["No patterns", "Overlapping subproblems", "Single solutions", "Random inputs"], correctIndex: 1),
            ]

        case "course_business_strategy":
            return [
                QuizQuestion(question: "Porter's Five Forces analyzes:", options: ["Employee satisfaction", "Industry competitiveness", "Stock prices", "Marketing trends"], correctIndex: 1),
                QuizQuestion(question: "What is a SWOT analysis?", options: ["A financial tool", "Strengths, Weaknesses, Opportunities, Threats", "A marketing channel", "A hiring framework"], correctIndex: 1),
                QuizQuestion(question: "Market positioning refers to:", options: ["Physical store location", "How a brand is perceived relative to competitors", "Product pricing only", "Number of employees"], correctIndex: 1),
            ]

        case "course_intro_psychology":
            return [
                QuizQuestion(question: "Who is the founder of psychoanalysis?", options: ["Skinner", "Freud", "Pavlov", "Jung"], correctIndex: 1),
                QuizQuestion(question: "Classical conditioning was demonstrated by:", options: ["Freud", "Watson", "Pavlov", "Maslow"], correctIndex: 2),
                QuizQuestion(question: "The 'bystander effect' relates to:", options: ["Memory", "Learning", "Social psychology", "Neuroscience"], correctIndex: 2),
            ]

        default:
            return [
                QuizQuestion(question: "Sample question?", options: ["A", "B", "C", "D"], correctIndex: 0),
            ]
        }
    }
}

#Preview {
    QuizView(
        courseName: "Algorithm Design",
        questions: CourseQuizStore.questions(for: "course_algorithm_design")
    )
>>>>>>> main
}
