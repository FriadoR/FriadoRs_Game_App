//
//  LottieView.swift
//  Wood Game
//
//  Created by Сергей Саченко on 21.02.2025.
//

import SwiftUI
import DotLottie


struct LottieView: View {
    @EnvironmentObject var woodManager: WoodManager
    @State private var navigateToWoodView = false
    @State private var showLoadingText = true
    @State private var cycleCount = 0
    
    var body: some View {
        
        NavigationStack {
            VStack {
                DotLottieAnimation(fileName: "loading", config: AnimationConfig(autoplay: true, loop: true))
                    .view()
                    .frame(width: 220, height: 220)
                
                VStack {
                    Text("Loading...")
                        .offset(CGSize(width: 7, height: 0))
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(.white)
                        .opacity(showLoadingText ? 1 : 0)
                        .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: showLoadingText)
                }
                .onAppear {
                    startAnimationCycle()
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.showLoadingText = false
                    }
                }
            }
            .padding(.bottom, 50)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea(.all)
            .background(Color.black)
            .navigationBarBackButtonHidden(true)
            .navigationDestination(isPresented: $navigateToWoodView) {
                WoodView()
                    .environmentObject(woodManager)
                    
            }
        }
    }
    func startAnimationCycle() {
        // Каждые 2 секунды (длительность одного цикла) увеличиваем счетчик
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.cycleCount += 1
            
            // Если циклов прошло 5, переходим на следующий экран
            if self.cycleCount >= 3 {
                navigateToWoodView = true
            } else {
                startAnimationCycle() // Повторяем цикл
            }
        }
    }
}

#Preview {
    LottieView()
        .environmentObject(WoodManager())
}
