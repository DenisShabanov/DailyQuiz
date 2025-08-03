//
//  DeveloperPreview.swift
//  DailyQuiz
//
//  Created by Denis Shabanov on 01.08.2025.
//
import Foundation

class DeveloperPreview {
    
    static let instance = DeveloperPreview()
    
    let vm = QuizViewModel()
    
    
    let answer: QuizModel
    let sampleQuestion: QuestionModel
    let sampleQuiz: HistoryQuizModel
    
    private init() {
        self.answer = QuizModel(
            type: "multiple",
            difficulty: "easy",
            category: "General Knowledge",
            question: "Five dollars is worth how many nickels?",
            correctAnswer: "100",
            incorrectAnswers:  [
                "50",
                "25",
                "69"
            ])
        self.sampleQuestion = QuestionModel(
            id: UUID(),
            text: "Столица Франции?",
            answers: ["Лондон", "Берлин", "Париж", "Мадрид"],
            correctAnswerIndex: 2
        )
        
        self.sampleQuiz = HistoryQuizModel(
            id: UUID(),
            date: Date(),
            totalQuestions: 1,
            correctAnswers: 1,
            difficulty: "easy",
            category: "General Knowledge",
            questions: [sampleQuestion],
            selectedAnswers: [2]
        )
    }
    
    
}
