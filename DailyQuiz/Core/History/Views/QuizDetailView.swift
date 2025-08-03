import SwiftUI

struct QuizDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var showHistoryScreen: Bool
    let quiz: HistoryQuizModel
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .center, spacing: 24) {
                ResultQuizCardView(
                    correctCount: quiz.questions.enumerated().filter { index, question in
                        question.correctAnswerIndex == quiz.selectedAnswers[index]
                    }.count,
                    totalCount: quiz.questions.count,
                    onRestart: nil, showButton: false
                )
                Text("Результаты")
                    .font(.largeTitle)
                    .bold()
                    .padding(.bottom)
                    .foregroundStyle(Color.theme.white)
                ForEach(quiz.questions.indices, id: \.self) { index in
                    let question = quiz.questions[index]
                    let selected = quiz.selectedAnswers[index]
                    let isCorrect = selected == question.correctAnswerIndex
                    
                    VStack(alignment: .center, spacing: 10) {
                        HStack {
                            Text("Вопрос \(index + 1) из \(quiz.questions.count)")
                                .font(.subheadline)
                                .foregroundStyle(Color.theme.disable)
                            
                            Spacer()
                            
                            Image(systemName: isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                                .foregroundStyle(isCorrect ? Color.theme.greenColor : Color.theme.redColor)
                        }
                        .padding()
                        Text(question.text)
                            .padding()
                            .font(.headline)
                            .foregroundStyle(Color.black)
                        QuizAnswerRow(question: question, selected: selected)
                    }
                    .padding()
                    .frame(width: 340, height: 443)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 46))
                    .multilineTextAlignment(.center)
                   
                }
                NextButtonView(isEnabled: true, buttonText: "Начать заново", action: { dismiss()
                    showHistoryScreen = false
                }, backgroundColor: Color.theme.white, textColor: Color.theme.darkPurple)
            }
            .padding()
        }
        .background(Color.theme.accent.ignoresSafeArea())
    }
}

#Preview {
    QuizDetailView(showHistoryScreen: .constant(false), quiz: DeveloperPreview.instance.sampleQuiz)
}
