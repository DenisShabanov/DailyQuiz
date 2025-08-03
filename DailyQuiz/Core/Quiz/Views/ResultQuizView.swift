//
//  ResultQuizView.swift
//  DailyQuiz
//
//  Created by Denis Shabanov on 02.08.2025.
//

import SwiftUI

struct ResultQuizView: View {
    @Environment(QuizViewModel.self) private var viewModel
    @Binding var showQuizView: Bool

    var body: some View {
        ResultQuizCardView(
            correctCount: viewModel.correctAnswersCount(),
            totalCount: viewModel.allAnswers.count,
            onRestart: {
                viewModel.finishQuizAndReturnHome()
                showQuizView = false
            }, showButton: true
        )
    }
}

#Preview {
    ResultQuizView(showQuizView: .constant(false))
        .environment(DeveloperPreview.instance.vm)
}
