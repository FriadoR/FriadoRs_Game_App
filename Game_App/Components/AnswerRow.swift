//
//  AnswerRow.swift
//  Game_App
//
//  Created by Сергей Саченко on 13.02.2025.
//

import SwiftUI

struct AnswerRow: View {
    @EnvironmentObject var woodManager: WoodManager
    var answer: Answer
    @State private var isSelected: Bool = false
    
    var green = Color(hue: 0.437, saturation: 0.711, brightness: 0.711)
    var red = Color(red: 0.71, green: 0.094, blue: 0.1)
    
    var body: some View {
        HStack(spacing: 20) {
            Image(systemName: "circle.fill")
                .font(.caption)
            
            Text(answer.text)
                .bold()
            
            if woodManager.answerSelected {
                Spacer()
                
                if answer.isCorrect {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(green)
                        .transition(.scale)
                }
                else if !answer.isCorrect && isSelected {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(red)
                        .transition(.scale)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .foregroundColor(woodManager.answerSelected ? (isSelected ? Color.textWood : .gray) : Color(hue: 1.0, saturation: 0.0, brightness: 0.661))
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
                .shadow(color: isSelected ? (answer.isCorrect ? green : red) : .gray, radius: 5, x: 0.5, y: 0.5)
        )
        .scaleEffect(isSelected ? 1.05 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: isSelected)
        .onTapGesture {
            if !woodManager.answerSelected {
                isSelected = true
                woodManager.selectAnswer(answer: answer)
            }
        }
    }
}

#Preview {
    AnswerRow(answer: Answer(text: "Single", isCorrect: false))
        .environmentObject(WoodManager())
}
