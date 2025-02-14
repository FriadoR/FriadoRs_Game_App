//
//  Wood.swift
//  Wood Game
//
//  Created by Сергей Саченко on 14.02.2025.
//

import Foundation

struct Wood: Decodable {
    var results: [Result]
    
    struct Result: Decodable, Identifiable {
        
        var id: UUID {
            UUID()
        }
        
        var category: String
        var type: String
        var difficulty: String
        var question: String
        var correctAnswer: String
        var incorrectAnswers: [String]
        
        var formatedQuestion: AttributedString {
            do {
                return try AttributedString(markdown: question)
            } catch {
                print("Error setting formatedQuestion: \(error)")
                return ""
            }
        }
    }
}
