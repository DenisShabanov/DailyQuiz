//
//  ResultAnswerLineView.swift
//  DailyQuiz
//
//  Created by Denis Shabanov on 02.08.2025.
//

import SwiftUI

struct ResultAnswerLineView: View {
    let answer: String
    let isSelected: Bool
    let isCorrect: Bool
    
    var body: some View {
        HStack {
            if isSelected {
                Circle()
                    .fill(isCorrect ? Color.theme.greenColor : Color.theme.redColor)
                    .overlay {
                        Image(isCorrect ? "checkmark_icon" : "xmark_icon")
                            .foregroundColor(Color.theme.white)
                            .font(.headline)
                    }
                    .frame(width: 20, height: 20)
                    .clipShape(Circle())
                    .padding(.leading)
                    .padding(.trailing, 4)
            } else {
                Circle()
                    .stroke(Color.black)
                    .frame(width: 20, height: 20)
                    .padding(.leading)
                    .padding(.trailing, 4)
            }
            
            Text(answer)
                .font(.callout)
                .foregroundColor(textColor)
            
            Spacer()
        }
        .frame(width: 280, height: 52)
        .background(isSelected ? Color.theme.white : Color.theme.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(borderColor)
        )
    }
    
    private var textColor: Color {
        if isSelected {
            return isCorrect ? .theme.greenColor : .theme.redColor
        } else {
            return .black
        }
    }
    
    private var borderColor: Color {
        if isSelected {
            return isCorrect ? .theme.greenColor : .theme.redColor
        } else {
            return Color.theme.cardBackground
        }
    }
}

#Preview {
    VStack(spacing: 16) {
        ResultAnswerLineView(answer: "Правильный ответ", isSelected: true, isCorrect: true)
        ResultAnswerLineView(answer: "Неправильный ответ", isSelected: true, isCorrect: false)
        ResultAnswerLineView(answer: "Не выбран", isSelected: false, isCorrect: false)
    }
}

