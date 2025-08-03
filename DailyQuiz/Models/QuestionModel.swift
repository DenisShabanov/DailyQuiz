//
//  QuestionModel.swift
//  DailyQuiz
//
//  Created by Denis Shabanov on 02.08.2025.
//

import Foundation

struct QuestionModel: Codable, Identifiable, Hashable {
    let id: UUID
    let text: String
    let answers: [String]
    let correctAnswerIndex: Int
}
