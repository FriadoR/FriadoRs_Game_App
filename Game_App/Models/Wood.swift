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
                let combinedText = "\(question)\n\(category)"
                return try AttributedString(markdown: combinedText)
            } catch {
                print("Error setting formatedQuestion: \(error)")
                return ""
            }
        }
        
        var answers: [Answer] {
            do {
               let correct = [Answer(text: try AttributedString(markdown: correctAnswer), isCorrect: true)]
                let incorrects = try incorrectAnswers.map { answer in
                    Answer(text: try AttributedString(markdown: answer), isCorrect: false)
                }
                
                let allAnswers = correct + incorrects
                return allAnswers.shuffled()
                
            } catch {
                print("Error setting answers: \(error)")
                return []
            }
        }
    }
}
