//
//  Answer.swift
//  Game_App
//
//  Created by Сергей Саченко on 13.02.2025.
//

import Foundation

struct Answer: Identifiable {
    var id: UUID = UUID()
    var text: AttributedString
    var isCorrect: Bool
}
