//
//  QuizDataService.swift
//  DailyQuiz
//
//  Created by Denis Shabanov on 01.08.2025.
//

import Foundation
import Combine

class QuizDataService {
    
    @Published
    var quizData: [QuizModel]? = nil
    var quizDataSubscription: AnyCancellable?
    
    init() {}
    
    func getAnswers () {
        
        guard let url = URL(string: "https://opentdb.com/api.php?amount=5&type=multiple&category=9&difficulty=easy")
        else {return}
        
        quizDataSubscription = URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .default))
            .tryMap({ (output) -> Data in
                guard let response = output.response as? HTTPURLResponse,
                      response.statusCode >= 200 && response.statusCode < 300 else {
                    throw URLError(.badServerResponse)
                }
                return output.data
            })
            .receive(on: DispatchQueue.main)
            .decode(type: GlobalData.self, decoder: JSONDecoder())
            .sink{ (completion) in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }receiveValue:  { [weak self] returnedGlobalData in
                guard let data = returnedGlobalData.results else { return }
                self?.quizData = data
                self?.quizDataSubscription?.cancel()
            }
    }
    
}
