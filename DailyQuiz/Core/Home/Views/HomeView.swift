//
//  HomeView.swift
//  DailyQuiz
//
//  Created by Denis Shabanov on 01.08.2025.
//

import SwiftUI

struct HomeView: View {
    @Environment(QuizViewModel.self)
    private var vm
    
    @State private var startQuiz: Bool = false
    @State private var isLoading: Bool = false
    @State private var showQuizView: Bool = false
    @State private var showHistoryScreen: Bool = false
    @State private var loadError: Bool = false
    
    var body: some View {
        ZStack{
            // background layer
            Color.theme.accent
                .ignoresSafeArea()
            //ContentLayer
            if showQuizView{
                QuizView(showQuizView: $showQuizView)
            }else if isLoading {
                VStack {
                    Image("logo").padding(.vertical, 40)
                    Image("loader")
                }
            }else {
                VStack{
                    historyButton
                    Spacer()
                    Image("logo").padding(.vertical, 40)
                    welcomeCard
                    if loadError == true {
                        Text("Ошибка! Попробуйте ещё раз")
                            .font(.headline)
                            .foregroundStyle(Color.theme.white)
                    }
                    Spacer()
                    Spacer()
                    Spacer()
                }
                .onChange(of: startQuiz) {
                    if startQuiz {
                        isLoading = true
                        loadError = false
                        vm.fetchQuizData()
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            isLoading = false
                            if vm.hasLoadError {
                                loadError = true
                                startQuiz = false
                            } else {
                                showQuizView = true
                            }
                        }
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $showHistoryScreen) {
            withAnimation(.easeInOut) {
                HistoryView(startQuiz: $startQuiz, showHistoryScreen: $showHistoryScreen)
            }
        }
    }
}

#Preview {
    HomeView()
        .environment(DeveloperPreview.instance.vm)
}

//Sub View
extension HomeView {
    
    private var welcomeCard: some View {
        VStack{
            Text("Добро пожаловать в DailyQuiz!")
                .font(.title)
                .foregroundStyle(Color.black)
                .fontWeight(.bold)
                .padding(.bottom, 30)
            
            ActiveButtonView(isTapped: $startQuiz)
        }
        .frame(width: 360, height: 222)
        .background(
            Color.theme.white
        )
        .clipShape(RoundedRectangle(cornerRadius: 46))
        .multilineTextAlignment(.center)
    }
    
    private var historyButton: some View {
        Button {
            showHistoryScreen = true
        } label: {
            HStack {
                Text("История")
                    .font(.headline)
                    .fontWeight(.semibold)
                Image("history")
            }
        }
        .padding()
        .background(
            Color.theme.white
        )
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .padding(.top)
    }
}
