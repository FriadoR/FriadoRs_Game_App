//
//  QuestionView.swift
//  Game_App
//
//  Created by Сергей Саченко on 13.02.2025.
//

import SwiftUI

struct QuestionView: View {
    @EnvironmentObject var woodManager: WoodManager
    
    var body: some View {
        VStack(spacing: 40) {
            HStack {
                Text("Wood Game")
                    .customTitle()
                
                Spacer()
                
                Text("\(woodManager.index + 1) out of \(woodManager.length)")
                    .foregroundColor(.accentColor)
                    .fontWeight(.heavy)
            }
            
            ProgressBar(progress: woodManager.progress)
            
            VStack(alignment: .leading, spacing: 20) {
                Text(woodManager.question)
                    .font(.system(size: 20))
                    .bold()
                    .foregroundColor(Color(hue: 1.0, saturation: 0.0, brightness: 0.661))
                
                ForEach(woodManager.answerChoices, id: \.id) { answer in
                    AnswerRow(answer: answer)
                        .environmentObject(woodManager)
                }
            }
            
            Button {
                woodManager.goToNextQuestion()
            } label: {
                PrimaryButton(text: "Next", background: woodManager.answerSelected ? Color.accentColor : Color(hue: 1.0, saturation: 0.0, brightness: 0.564, opacity: 0.327))
            }
            .disabled(!woodManager.answerSelected)
            
            Spacer()
            
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(red: 38/255, green: 92/255, blue: 75/255))
        .navigationBarHidden(true)
    }
}

#Preview {
    QuestionView()
        .environmentObject(WoodManager())
}
