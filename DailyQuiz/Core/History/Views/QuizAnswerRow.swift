//
//  QuizAnswerRow.swift
//  DailyQuiz
//
//  Created by Denis Shabanov on 02.08.2025.
//

import SwiftUI

struct QuizAnswerRow: View {
    let question: QuestionModel
    let selected: Int
    
    var body: some View {
            ForEach(question.answers.indices, id: \.self) { answerIndex in
                let isCorrect = answerIndex == question.correctAnswerIndex
                let isSelected = answerIndex == selected
                
                ResultAnswerLineView(
                    answer: question.answers[answerIndex],
                    isSelected: isSelected,
                    isCorrect: isCorrect
                )
            }
        }
}


#Preview {
    QuizAnswerRow(question: DeveloperPreview.instance.sampleQuestion, selected: 0)
}
