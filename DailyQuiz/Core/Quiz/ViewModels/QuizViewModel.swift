//
//  QuizViewModel.swift
//  DailyQuiz
//
//  Created by Denis Shabanov on 01.08.2025.
//

import Foundation
import Combine
import CoreData

@Observable
class QuizViewModel {
    // MARK: Quiz Data
    var allAnswers: [QuizModel] = []
    var quizHistory: [HistoryQuizModel] = []
    
    private let quizDataService = QuizDataService()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - State for quiz
    var currentQuestionIndex: Int = 0
    var selectedAnswer: String? = nil
    var shuffledAnswers: [[String]] = []
    var isQuizCompleted: Bool = false
    
    var hasLoadError: Bool = false
    
    
    var selectedAnswers: [String?] = []
    
    init() {
        addSubscribers()
        loadHistoryFromCoreData()
    }
    
    func addSubscribers() {
        quizDataService.$quizData
            .sink { [weak self] returnedQuiz in
                guard let self = self else { return }
                guard let returnedQuiz = returnedQuiz else { return }
                
                self.allAnswers = returnedQuiz
                self.prepareShuffledAnswers()
                self.initializeQuizState()
            }
            .store(in: &cancellables)
    }
    
    private func initializeQuizState() {
        currentQuestionIndex = 0
        selectedAnswer = nil
        selectedAnswers = Array(repeating: nil, count: allAnswers.count)
        isQuizCompleted = false
    }
    
    func fetchQuizData() {
        quizDataService.getAnswers()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
                guard let self = self else { return }
                if self.allAnswers.isEmpty {
                    self.hasLoadError = true
                } else {
                    self.hasLoadError = false
                }
            }
    }
    
    private func prepareShuffledAnswers() {
        shuffledAnswers = allAnswers.map { answer in
            ([answer.correctAnswer] + (answer.incorrectAnswers ?? [])).compactMap { $0 }.shuffled()
        }
    }
    
    func selectAnswer(_ answer: String) {
        selectedAnswer = answer
    }
    
    func nextQuestion() {
        if let selected = selectedAnswer {
            if currentQuestionIndex < selectedAnswers.count {
                selectedAnswers[currentQuestionIndex] = selected
            }
        }
        selectedAnswer = nil
        
        if currentQuestionIndex < allAnswers.count - 1 {
            currentQuestionIndex += 1
        } else {
            isQuizCompleted = true
        }
    }
    
    func correctAnswersCount() -> Int {
        var count = 0
        for (index, selected) in selectedAnswers.enumerated() {
            if index < allAnswers.count,
               let selected = selected,
               selected == allAnswers[index].correctAnswer {
                count += 1
            }
        }
        return count
    }
    func finishQuizAndReturnHome() {
        saveResult()
        resetQuiz()
    }
    
    func deleteQuiz(id: UUID) {
        quizHistory.removeAll { $0.id == id }
        QuizHistoryDataService.shared.deleteQuiz(with: id)
    }
    
    func resetQuiz() {
        allAnswers = []
        shuffledAnswers = []
        selectedAnswers = []
        currentQuestionIndex = 0
        selectedAnswer = nil
        isQuizCompleted = false
    }
    
    func saveResult() {
        let shuffledAnswers: [[String]] = allAnswers.map {
            ([ $0.correctAnswer ] + ($0.incorrectAnswers ?? [])).compactMap { $0 }.shuffled()
        }

        let questionModels: [QuestionModel] = allAnswers.enumerated().map { index, quiz in
            let answers = shuffledAnswers[index]
            let correctIndex = quiz.correctAnswer.flatMap { answers.firstIndex(of: $0) } ?? 0
            return QuestionModel(
                id: UUID(),
                text: quiz.question ?? "Неизвестный вопрос",
                answers: answers,
                correctAnswerIndex: correctIndex
            )
        }

        let selectedIndexes: [Int] = selectedAnswers.enumerated().map { index, answer in
            let answers = shuffledAnswers[index]
            return answer.flatMap { answers.firstIndex(of: $0) } ?? -1
        }

        let result = HistoryQuizModel(
            id: UUID(),
            date: Date(),
            totalQuestions: allAnswers.count,
            correctAnswers: correctAnswersCount(),
            difficulty: allAnswers.first?.difficulty ?? "",
            category: allAnswers.first?.category ?? "",
            questions: questionModels,
            selectedAnswers: selectedIndexes
        )

        quizHistory.insert(result, at: 0)
        saveToCoreData(result)
    }
    
    private func saveToCoreData(_ result: HistoryQuizModel) {
        let context = QuizHistoryDataService.shared.context
        let entity = HistoryEntity(context: context)
        
        entity.id = result.id
        entity.date = result.date
        entity.correctAnswers = Int16(result.correctAnswers)
        
        let encoder = JSONEncoder()
        entity.questions = try? encoder.encode(result.questions)
        entity.selectedAnswers = try? encoder.encode(result.selectedAnswers)
        
        QuizHistoryDataService.shared.saveContext()
    }
    
    func loadHistoryFromCoreData() {
        let entities = QuizHistoryDataService.shared.fetchAllHistory()
        let decoder = JSONDecoder()
        
        self.quizHistory = entities.compactMap { entity in
            guard
                let id = entity.id,
                let date = entity.date,
                let questionsData = entity.questions,
                let selectedAnswersData = entity.selectedAnswers,
                let questions = try? decoder.decode([QuestionModel].self, from: questionsData),
                let selectedAnswers = try? decoder.decode([Int].self, from: selectedAnswersData)
            else {
                return nil
            }
            
            return HistoryQuizModel(
                id: id,
                date: date,
                totalQuestions: questions.count,
                correctAnswers: Int(entity.correctAnswers),
                difficulty: "", // если хочешь, можешь добавить эти поля в Core Data
                category: "",
                questions: questions,
                selectedAnswers: selectedAnswers
            )
        }
    }
}
