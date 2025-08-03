//
//  QuizView.swift
//  DailyQuiz
//
//  Created by Denis Shabanov on 01.08.2025.
//

import SwiftUI

struct QuizView: View {
    @Environment(QuizViewModel.self)
    private var viewModel
    @Binding var showQuizView: Bool
    @State private var isTimerRunning: Bool = true
    @State private var timeIsUp: Bool = false
    
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
                        .frame(width: 340, height: 580)
                        .foregroundStyle(Color.theme.white)
                } else if viewModel.isQuizCompleted {
                    ResultQuizView(showQuizView: $showQuizView)
                } else {
                    quizCard
                    warningUnderCard
                }
                Spacer()
            }
            .disabled(timeIsUp)
            .padding(.horizontal, 26)
            if timeIsUp {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .transition(.opacity)
                
                ifTimeIsUp
                    .transition(.scale)
            }
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
                
                QuizTimerView(isRunning: $isTimerRunning) {
                    withAnimation {
                        timeIsUp = true
                    }
                    isTimerRunning = false
                }
                Text("Вопрос \(index + 1) из \(viewModel.allAnswers.count)")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.theme.secondary)
                    .padding()
                
                Text(answer.question?.cleanedHTMLString ?? "")
                    .foregroundStyle(Color.black)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .padding(.horizontal)
                ForEach(options, id: \.self) { option in
                    AnswerLineView(answer: option.cleanedHTMLString, isSelected: viewModel.selectedAnswer == option,)
                        .padding(.vertical, 4)
                        .onTapGesture {
                            viewModel.selectAnswer(option)
                        }
                }
            
                NextButtonView(
                    isEnabled: viewModel.selectedAnswer != nil,
                    buttonText: index >= viewModel.allAnswers.count - 1 ? "Завершить Тест" : "Далее",
                    action: {
                        viewModel.nextQuestion()
                    }
                )
                .padding(.vertical)
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
    
    private var ifTimeIsUp: some View {
        VStack(alignment: .center, spacing: 20) {
            Text("Время вышло!")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color.black)
            Text("Вы не успели завершить викторину. Попробоуйте ещё раз")
                .font(.headline)
                .foregroundColor(Color.black)
            
            NextButtonView(isEnabled: true, buttonText: "Начать заново", action: {
                showQuizView = false
            })
        }
        .padding()
        .frame(width: 360, height: 233)
        .background(Color.theme.white)
        .cornerRadius(46)
        .multilineTextAlignment(.center)
    }
}
