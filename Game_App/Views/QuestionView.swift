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
                Text("")
            }
            
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(red: 38/255, green: 92/255, blue: 75/255))
    }
}

#Preview {
    QuestionView()
}
