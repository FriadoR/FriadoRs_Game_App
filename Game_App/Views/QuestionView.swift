//
//  QuestionView.swift
//  Game_App
//
//  Created by Сергей Саченко on 13.02.2025.
//

import SwiftUI

struct QuestionView: View {
    var body: some View {
        VStack(spacing: 40) {
            HStack {
                Text("Wood Game")
                    .customTitle()
                
                Spacer()
                
                Text("1 out of 10")
                    .foregroundColor(.accentColor)
                    .fontWeight(.heavy)
            }
            
            ProgressBar(progress: 10)
            
            VStack(alignment: .leading, spacing: 20) {
                Text("What is the most challenging monster in the Dungeons &amp; Dragons 5th Edition Monster Manual?")
                    .font(.system(size: 20))
                    .bold()
                    .foregroundColor(Color(hue: 1.0, saturation: 0.0, brightness: 0.661))
                
                AnswerRow(answer: Answer(text: "false", isCorrect: true))
                AnswerRow(answer: Answer(text: "true", isCorrect: false))
            }
            
            PrimaryButton(text: "Next")
            
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
}
