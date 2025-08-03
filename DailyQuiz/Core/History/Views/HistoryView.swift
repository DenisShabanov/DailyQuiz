//
//  HistoryView.swift
//  DailyQuiz
//
//  Created by Denis Shabanov on 02.08.2025.
//

import SwiftUI

struct HistoryView: View {
    
    @Environment(QuizViewModel.self)
    var viewModel
    @Environment(\.dismiss) var dismiss
    @Binding var startQuiz: Bool
    @Binding var showHistoryScreen: Bool
    @State var isTapped: Bool = false
    @State private var selectedQuizID: UUID?
    @State private var showDeleteAlert: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // background layer
                Color.theme.accent
                    .ignoresSafeArea()
                
                VStack {
                    historyHeader
                        .padding(.top)
                    if viewModel.quizHistory.isEmpty {
                        isEmptyCard
                        
                        Spacer()
                        footerLogo
                    } else {
                        historyScrollView
                    }
                }
                if selectedQuizID != nil {
                    Color.clear
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedQuizID = nil
                        }
                }
                if showDeleteAlert {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                    showAlertVindow
                }
            }
        }
        
    }
}

#Preview {
    HistoryView(startQuiz: .constant(false), showHistoryScreen: .constant(false))
        .environment(DeveloperPreview.instance.vm)
}

extension HistoryView {
    
    private var historyHeader: some View {
        HStack {
            Button(action: {
                dismiss()
            }) {
                Image(systemName: "chevron.left")
                    .foregroundColor(.white)
                    .padding()
                    .font(.headline)
            }
            Spacer()
            Text("История")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(Color.theme.white)
            Spacer()
            Spacer()
        }
    }
    
    private var isEmptyCard: some View {
        VStack {
            Text("Вы ещё не проходили ни одной викторины")
                .font(.title2)
                .padding()
                .foregroundStyle(Color.black)
            ActiveButtonView(isTapped: $startQuiz)
                .padding(.top, 15)
                .onAppear {
                    isTapped = false
                }
                .onChange(of: startQuiz) {
                    dismiss()
                }
        }
        .frame(width: 360, height: 202)
        .background(Color.theme.white)
        .clipShape(RoundedRectangle(cornerRadius: 46))
        .padding(.vertical, 20)
        .multilineTextAlignment(.center)
    }
    
    private func historyCard(for quiz: HistoryQuizModel, count: Int) -> some View {
        NavigationLink {
            QuizDetailView(showHistoryScreen: $showHistoryScreen, quiz: quiz)
        } label: {
            historyCardContent(for: quiz, count: count + 1)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func historyCardContent(for quiz: HistoryQuizModel, count: Int) -> some View {
        
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Quiz \(count)")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.theme.darkPurple)
                Spacer()
                
                ForEach(0..<5, id: \.self) { index in
                    Image("Star_icon")
                        .renderingMode(.template)
                        .resizable()
                        .frame(width: 16, height: 16)
                        .foregroundColor(index < quiz.correctAnswers ? .yellow : .gray)
                    
                }
            }
            HStack {
                Text(quiz.date.formatDayMonth())
                    .font(.headline)
                    .foregroundStyle(Color.black)
                
                Spacer()
                
                Text(quiz.date.formatTime())
                    .font(.headline)
                    .foregroundStyle(Color.black)
            }
        }
        .padding(26)
        .frame(width: 340, height: 104)
        .background(Color.theme.white)
        .clipShape(RoundedRectangle(cornerRadius: 40))
        .contextMenu {
            Button {
                viewModel.deleteQuiz(id: quiz.id )
                showDeleteAlert = true
            } label: {
                Label("Удалить", image: "iconamoon_trash")
                    .foregroundStyle(Color.theme.redColor)
            }
        }
    }
    
    private var historyScrollView: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(Array(viewModel.quizHistory.enumerated()), id: \.element.id) { index, quiz in
                    historyCard(for: quiz, count: index + 1)
                        .onTapGesture {
                            selectedQuizID = quiz.id
                        }
                        .overlay(
                            Group {
                                if let selected = selectedQuizID, selected != quiz.id {
                                    Color.black.opacity(0.4)
                                }
                            }
                        )
                        .zIndex(selectedQuizID == quiz.id ? 1 : 0)
                }
            }
            .padding(.horizontal, 26)
        }
    }
    
    
    
    private var footerLogo: some View {
        VStack {
            Spacer()
            Spacer()
            Image("logo")
            Spacer()
        }
    }
    
    private var showAlertVindow: some View {
        VStack{
            Text("Попытка удалена")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(Color.black)
                .padding(.top, 16)
            Text("Вы можете пройти викторину снова когда будете готовы")
                .font(.headline)
                .fontWeight(.medium)
                .foregroundStyle(Color.black)
            NextButtonView(isEnabled: true, buttonText: "хорошо", action: { showDeleteAlert = false
            })
            .padding(.vertical, 20)
        }
        .padding()
        .frame(width: 360, height: 233)
        .background(Color.theme.white)
        .clipShape(RoundedRectangle(cornerRadius: 46))
        .multilineTextAlignment(.center)
    }
}
