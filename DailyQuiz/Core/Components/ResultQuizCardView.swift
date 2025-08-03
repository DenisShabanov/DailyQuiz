//
//  ResultQuizCardView.swift
//  DailyQuiz
//
//  Created by Denis Shabanov on 03.08.2025.
//

import SwiftUI

enum ResultText {
    case zero
    case one
    case two
    case three
    case four
    case five

    init(correctAnswers: Int) {
        switch correctAnswers {
        case 0: self = .zero
        case 1: self = .one
        case 2: self = .two
        case 3: self = .three
        case 4: self = .four
        case 5: self = .five
        default:
            self = .zero
        }
    }

    var description: (title: String, subtitle: String) {
        switch self {
        case .zero:
            return ("Бывает и так!", "0/5 - не отчаивайтесь. Начните заново и удивите себя!")
        case .one:
            return ("Сложный вопрос?", "1/5 — иногда просто не ваш день. Следующая попытка будет лучше!")
        case .two:
            return ("Есть над чем поработать", "2/5 — не расстраивайтесь, попробуйте ещё раз!")
        case .three:
            return ("Хороший результат", "3/5 — вы на верном пути. Продолжайте тренироваться!")
        case .four:
            return ("Почти идеально!", "4/5 — очень близко к совершенству. Ещё один шаг!")
        case .five:
            return ("Идеально!", "5/5 — вы ответили на всё правильно. Это блестящий результат!")
        }
    }
}

struct ResultQuizCardView: View {
    let correctCount: Int
    let totalCount: Int
    var onRestart: (() -> Void)? = nil
    @State var showButton: Bool

    var body: some View {
        let result = ResultText(correctAnswers: correctCount)

        VStack(spacing: 20) {
            HStack(spacing: 8) {
                ForEach(0..<5, id: \.self) { index in
                    Image("Star_icon")
                        .renderingMode(.template)
                        .resizable()
                        .frame(width: 52, height: 52)
                        .foregroundColor(index < correctCount ? .theme.yellowColor : .theme.disable)
                }
            }

            Text("\(correctCount) из \(totalCount)")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(Color.theme.yellowColor)

            Text(result.description.title)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(Color.black)

            Text(result.description.subtitle)
                .font(.headline)
                .fontWeight(.medium)
                .foregroundStyle(Color.black)

            if showButton {
                if let onRestart {
                    NextButtonView(isEnabled: true, buttonText: "Начать заново", action: onRestart)
                }
            }
        }
        .padding()
        .frame(width: 340, height: showButton ? 376 : 262)
        .background(Color.theme.white)
        .clipShape(RoundedRectangle(cornerRadius: 46))
        .multilineTextAlignment(.center)
    }
}


#Preview {
    ResultQuizCardView(correctCount: 0, totalCount: 0, showButton: true)
}
