//
//  WoodView.swift
//  Game_App
//
//  Created by Сергей Саченко on 13.02.2025.
//

import SwiftUI
import DotLottie

struct WoodView: View {
    @EnvironmentObject var woodManager: WoodManager
    @State private var selectedDifficulty: String = "easy"
    @State private var selectedCategory: String = "11"
    
    var body: some View {
        if woodManager.reachedEnd {
            NavigationStack {
                VStack(spacing: 20) {
                    
                    DotLottieAnimation(fileName: "theEnd", config: AnimationConfig(autoplay: true, loop: true))
                        .view()
                        .frame(width: 220, height: 220)
                    
                    Text("Game over!")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("Congratulations, you completed the game! 🎉")
                    
                    Text("You scored \(woodManager.score) out of \(woodManager.length)")
                    
                    Button {
                        Task {
                            await woodManager.fetchWood(category: selectedCategory, difficulty: selectedDifficulty)
                        }
                    } label: {
                        PrimaryButton(text: "Play again?")
                    }
                    
                    NavigationLink {
                        ContentView()
                            .environmentObject(woodManager)
                    } label: {
                        PrimaryButton(text: "Main menu")
                    }
                }
                .foregroundColor(.white)
                .padding(.bottom, 170)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .woodBackground()
            }
            .navigationBarBackButtonHidden(true)
        } else {
            QuestionView()
                .environmentObject(woodManager)
        }
    }
}

#Preview {
    WoodView()
        .environmentObject(WoodManager())
}
