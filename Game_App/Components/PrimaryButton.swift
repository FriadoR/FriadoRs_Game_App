//
//  PrimaryButton.swift
//  Game_App
//
//  Created by Сергей Саченко on 12.02.2025.
//

import SwiftUI

struct PrimaryButton: View {
    var text: String
    var background: Color = Color("AccentWoodColor")
    
    var body: some View {
        Text(text)
            .foregroundColor(Color(.textWood))
            .padding()
            .padding(.horizontal)
            .background(background)
            .cornerRadius(30)
            .shadow(radius: 15)
    }
}

#Preview {
    PrimaryButton(text: "Next")
}
