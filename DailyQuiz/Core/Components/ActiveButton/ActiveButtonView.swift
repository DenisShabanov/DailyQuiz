//
//  ActiveButtonView.swift
//  DailyQuiz
//
//  Created by Denis Shabanov on 01.08.2025.
//

import SwiftUI

enum ButtonOptional {
    case destination
    case next
}

struct ActiveButtonView: View {
    @Environment(QuizViewModel.self)
    private var vm
    
    @Binding
    var isTapped: Bool
    let buttonText: String = "Начать викторину"
    
    var body: some View {
        Button {
            isTapped.toggle()
            vm.fetchQuizData()
        } label: {
            Text(buttonText.uppercased())
                .foregroundStyle(Color.theme.white)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .contentShape(Rectangle())
        }
        .padding()
        .frame(width: 280, height: 50)
        .background(
            Color.theme.accent
        )
        .clipShape(RoundedRectangle(cornerRadius: 16))
        
    }
}

#Preview {
    ActiveButtonView(isTapped: .constant(false))
        .environment(DeveloperPreview.instance.vm)
}
