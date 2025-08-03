//
//  QuizTimerView.swift
//  DailyQuiz
//
//  Created by Denis Shabanov on 03.08.2025.
//

import SwiftUI
import Combine

struct QuizTimerView: View {
    let totalTime: TimeInterval = 5 * 60
    
    @Binding var isRunning: Bool
    var onTimerFinished: (() -> Void)? = nil
    
    @State private var elapsedTime: TimeInterval = 0
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text(elapsedTime.formattedMinutesSeconds)
                    .font(.caption)
                    .foregroundStyle(Color.theme.darkPurple)
                
                Spacer()
                
                Text(totalTime.formattedMinutesSeconds)
                    .font(.caption)
                    .foregroundStyle(Color.theme.darkPurple)
            }
            
            ProgressView(value: elapsedTime / totalTime)
                .progressViewStyle(LinearProgressViewStyle(tint: Color.theme.darkPurple))
                .frame(height: 6)
                .background(Color.gray.opacity(0.3))
                .clipShape(Capsule())
        }
        .padding(.horizontal, 34)
        .padding(.top, 14)
        .onReceive(timer) { _ in
            guard isRunning else { return }
            if elapsedTime < totalTime {
                elapsedTime += 1
            } else {
                isRunning = false
                onTimerFinished?()
            }
        }
        .onChange(of: isRunning) {
            if isRunning {
                elapsedTime = 0
            }
        }
    }
    
    private var timer: Publishers.Autoconnect<Timer.TimerPublisher> {
        Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    }
}


#Preview {
    QuizTimerView(isRunning: .constant(true))
}
