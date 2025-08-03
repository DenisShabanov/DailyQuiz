//
//  Date.swift
//  DailyQuiz
//
//  Created by Denis Shabanov on 02.08.2025.
//

import Foundation

extension Date {
    
    func formatDayMonth() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "dd MMMM"
        return formatter.string(from: self)
    }
    
    func formatTime() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: self)
    }
}
