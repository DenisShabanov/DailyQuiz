//
//  AnswerLineView.swift
//  DailyQuiz
//
//  Created by Denis Shabanov on 01.08.2025.
//

import SwiftUI

struct AnswerLineView: View {
    let answer: String
    let isSelected: Bool
    
    var body: some View {
        HStack {
            if isSelected {
                Circle()
                    .overlay {
                        Image("checkmark_icon")
                    }
                    .frame(width: 20, height: 20)
                    .padding(.leading)
                    .padding(.trailing, 4)
            } else {
                Circle()
                    .stroke()
                    .frame(width: 20, height: 20)
                    .padding(.leading)
                    .padding(.trailing, 4)
            }
            Text(answer)
                .font(.callout)
            Spacer()
        }
        .foregroundStyle(isSelected ? Color.theme.darkPurple : Color.black)
        .frame(width: 280, height: 52)
        .background(Color.theme.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(isSelected ? Color.theme.darkPurple : Color.theme.cardBackground)
        )
    }
}

#Preview {
    struct AnswerLineViewPreview: View {
        @State private var isSelected: Bool = true
        var body: some View {
            AnswerLineView(answer: "", isSelected: isSelected)
        }
    }
    return AnswerLineViewPreview()
}




