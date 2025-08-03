//
//  TimeInterval.swift
//  DailyQuiz
//
//  Created by Denis Shabanov on 03.08.2025.
//

import Foundation

extension TimeInterval {
    var formattedMinutesSeconds: String {
        let minutes = Int(self) / 60
        let seconds = Int(self) % 60
        return String(format: "%01d:%02d", minutes, seconds)
    }
}
