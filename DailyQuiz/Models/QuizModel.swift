//
//  QuizAnswers.swift
//  DailyQuiz
//
//  Created by Denis Shabanov on 01.08.2025.
//

//JSONE responce
/*
 URL: https://opentdb.com/api.php?amount=5&type=multiple&category=9&difficulty=easy
 
 {
   "response_code": 0,
   "results": [
     {
       "type": "multiple",
       "difficulty": "easy",
       "category": "General Knowledge",
       "question": "Five dollars is worth how many nickels?",
       "correct_answer": "100",
       "incorrect_answers": [
         "50",
         "25",
         "69"
       ]
     },
     {
       "type": "multiple",
       "difficulty": "easy",
       "category": "General Knowledge",
       "question": "If you are caught &quot;Goldbricking&quot;, what are you doing wrong?",
       "correct_answer": "Slacking",
       "incorrect_answers": [
         "Smoking",
         "Stealing",
         "Cheating"
       ]
     },
     {
       "type": "multiple",
       "difficulty": "easy",
       "category": "General Knowledge",
       "question": "Which of the following presidents is not on Mount Rushmore?",
       "correct_answer": "John F. Kennedy",
       "incorrect_answers": [
         "Theodore Roosevelt",
         "Abraham Lincoln",
         "Thomas Jefferson"
       ]
     },
     {
       "type": "multiple",
       "difficulty": "easy",
       "category": "General Knowledge",
       "question": "What was the name of the WWF professional wrestling tag team made up of the wrestlers Ax and Smash?",
       "correct_answer": "Demolition",
       "incorrect_answers": [
         "The Dream Team",
         "The Bushwhackers",
         "The British Bulldogs"
       ]
     },
     {
       "type": "multiple",
       "difficulty": "easy",
       "category": "General Knowledge",
       "question": "How would one say goodbye in Spanish?",
       "correct_answer": "Adi&oacute;s",
       "incorrect_answers": [
         " Hola",
         "Au Revoir",
         "Salir"
       ]
     }
   ]
 }
 */


import Foundation

struct GlobalData: Codable {
    let responseCode: Int?
    let results: [QuizModel]?
    
    enum CodingKeys: String, CodingKey {
        case responseCode = "response_code"
        case results
    }
}


struct QuizModel: Identifiable,Hashable, Codable {
    let id = UUID().uuidString
    let type, difficulty, category, question: String?
    let correctAnswer: String?
    let incorrectAnswers: [String]?
    
    enum CodingKeys: String, CodingKey {
        case type, difficulty, category, question, id
        case correctAnswer = "correct_answer"
        case incorrectAnswers = "incorrect_answers"
    }
}

extension QuizModel {
    func toQuestionModel() -> QuestionModel {
        let allAnswers = ([correctAnswer] + (incorrectAnswers ?? [])).compactMap { $0 }.shuffled()
        let correctIndex = correctAnswer.flatMap { allAnswers.firstIndex(of: $0) } ?? 0
        
        return QuestionModel(
            id: UUID(),
            text: question ?? "Вопрос недоступен",
            answers: allAnswers,
            correctAnswerIndex: correctIndex
        )
    }
}

