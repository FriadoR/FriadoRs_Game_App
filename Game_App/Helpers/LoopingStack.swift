//
//  LoopingStack.swift
//  Wood Game
//
//  Created by Сергей Саченко on 06.03.2025.
//

import SwiftUI

struct LoopingStack<Difficulty: View>: View {
    @ViewBuilder var content: Difficulty
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    DifficultySelectionView()
}
