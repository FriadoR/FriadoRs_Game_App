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
                    .foregroundColor(.textWood)
                    .fontWeight(.heavy)
            }
            
            ProgressBar(progress: woodManager.progress)
            
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Text(woodManager.question)
                        .font(.system(size: 20))
                        .bold()
                        .foregroundColor(Color(hue: 1.0, saturation: 0.0, brightness: 0.661))
                    
                    Spacer()
                    
                    Text(woodManager.currentDifficulty)
                        .font(.system(size: 16))
                        .bold()
                        .padding(8)
                        .foregroundColor(.white)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(self.difficultyColor(for: woodManager.currentDifficulty))
                        )
                    
                }
                
                ForEach(woodManager.answerChoices, id: \.id) { answer in
                    AnswerRow(answer: answer)
                        .environmentObject(woodManager)
                }
            }
            
            Button {
                woodManager.goToNextQuestion()
            } label: {
                PrimaryButton(text: "Next", background: woodManager.answerSelected ? Color(.accentWood) : Color(hue: 1.0, saturation: 0.0, brightness: 0.564, opacity: 0.327))
            }
            .disabled(!woodManager.answerSelected)
            
            Spacer()
            
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.accentWood))
        .navigationBarHidden(true)
    }
    
    private func difficultyColor(for difficulty: String) -> Color {
        switch difficulty.lowercased() {
        case "easy":
            return Color.green
        case "medium":
            return Color.orange
        case "hard":
            return Color.red
        default:
            return Color.gray
        }
    }
}



#Preview {
    QuestionView()
        .environmentObject(WoodManager())
}
