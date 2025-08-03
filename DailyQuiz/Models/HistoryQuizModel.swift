//
//  HistoryQuizModel.swift
//  DailyQuiz
//
//  Created by Denis Shabanov on 02.08.2025.
//

import Foundation

struct HistoryQuizModel: Identifiable, Codable {
    let id: UUID
    let date: Date
    let totalQuestions: Int
    let correctAnswers: Int
    let difficulty: String
    let category: String
    
    let questions: [QuestionModel]
    let selectedAnswers: [Int]
}
