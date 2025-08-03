import SwiftUI

struct QuizView: View {
    @Environment(QuizViewModel.self)
    private var viewModel
    @Binding var showQuizView: Bool
    
    var body: some View {
        ZStack {
            Color.theme.accent
                .ignoresSafeArea()
            
            VStack {
                if viewModel.isQuizCompleted{
                    Text("Результаты")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.theme.white)
                }else{
                    quizHeader
                }
                Spacer()
                
                if viewModel.allAnswers.isEmpty {
                    ProgressView("Загрузка вопросов...")
                        .frame(width: 340, height: 548)
                } else if viewModel.isQuizCompleted {
                    ResultQuizView(showQuizView: $showQuizView)
                } else {
                    quizCard
                    warningUnderCard
                }
                Spacer()
            }
            .padding(.horizontal, 26)
        }
    }
}

#Preview {
    QuizView(showQuizView: .constant(false))
        .environment(DeveloperPreview.instance.vm)
}

// MARK: - Subviews

extension QuizView {
    
    private var quizHeader: some View {
        HStack {
            Image("logo")
                .resizable()
                .scaledToFit()
                .frame(width: 180, height: 41)
        }
    }
    
    private var quizCard: some View {
        VStack {
            let index = viewModel.currentQuestionIndex
            
            if viewModel.allAnswers.indices.contains(index),
               viewModel.shuffledAnswers.indices.contains(index) {
                
                let answer = viewModel.allAnswers[index]
                let options = viewModel.shuffledAnswers[index]
                
                Text("Вопрос \(index + 1) из \(viewModel.allAnswers.count)")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.theme.secondary)
                    .padding()
                
                Text(answer.question?.cleanedHTMLString ?? "")
                    .foregroundStyle(Color.black)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 15)
                    .padding(.bottom, 20)
                
                ForEach(options, id: \.self) { option in
                    AnswerLineView(answer: option, isSelected: viewModel.selectedAnswer == option,)
                        .padding(.vertical, 4)
                        .onTapGesture {
                            viewModel.selectAnswer(option)
                        }
                }
                
                Spacer()
                
                NextButtonView(
                    isEnabled: viewModel.selectedAnswer != nil,
                    buttonText: index >= viewModel.allAnswers.count - 1 ? "Завершить Тест" : "Далее",
                    action: {
                        viewModel.nextQuestion()
                    }
                )
                .padding(.vertical, 40)
            } else {
                ProgressView("Загрузка вопроса...")
                    .frame(width: 340, height: 548)
            }
        }
        .frame(width: 340, height: 548)
        .background(Color.theme.white)
        .clipShape(RoundedRectangle(cornerRadius: 46))
        .multilineTextAlignment(.center)
    }
    
    private var warningUnderCard: some View {
        Text("Вернуться к предыдущим вопросам нельзя")
            .font(.caption)
            .foregroundStyle(Color.theme.white)
            .padding()
    }
}
