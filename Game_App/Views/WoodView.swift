//
//  WoodView.swift
//  Game_App
//
//  Created by Сергей Саченко on 13.02.2025.
//

import SwiftUI

struct WoodView: View {
    @EnvironmentObject var woodManager: WoodManager
    
    var body: some View {
        if woodManager.reachedEnd {
            VStack(spacing: 20) {
                
                Text("Game over!")
                    .customTitle()
                
                Text("Congratulations, you completed the game! 🎉")
                
                
                
                Text("Your scored \(woodManager.score) out of \(woodManager.length)")
                
                
                Button {
                    Task.init {
                        await woodManager.fetchWood()
                    }
                } label: {
                    PrimaryButton(text: "Play again?")
                }
            }
            .foregroundColor(Color.textWood)
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.accentWood)
            
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
