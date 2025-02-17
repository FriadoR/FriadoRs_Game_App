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
                
                Text("Вы прошли игру!")
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
            .foregroundColor(Color.accentColor)
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(red: 38/255, green: 92/255, blue: 75/255))
            
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
