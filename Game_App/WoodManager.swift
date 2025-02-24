//
//  WoodManager.swift
//  Wood Game
//
//  Created by Сергей Саченко on 14.02.2025.
//

import Foundation
import Combine

class WoodManager: ObservableObject {
    private(set) var wood: [Wood.Result] = []
    @Published private(set) var length = 0
    @Published private(set) var index = 0
    @Published private(set) var reachedEnd = false
    @Published private(set) var answerSelected = false
    @Published private(set) var question: AttributedString = ""
    @Published private(set) var answerChoices: [Answer] = []
    @Published private(set) var progress: CGFloat = 0.00
    @Published private(set) var score = 0
    @Published private(set) var showCorrectAnswer = false
    @Published private(set) var currentCategory: String = ""
    @Published private(set) var currentDifficulty: String = ""
    
    // Default values for the first load
    @Published var selectedDifficulty: String = "easy"
    @Published var selectedCategory: String = "15" // Default category for "Books"
    
    // Creating an instance of APIService
    private let apiService = APIService()
    
    // Fetch questions with specific category and difficulty
    func fetchWood(category: String, difficulty: String) async {
        do {
            let decodedData = try await apiService.fetchWood(category: category, difficulty: difficulty)
            
            Task { @MainActor in
                self.index = 0
                self.score = 0
                self.progress = 0.00
                self.reachedEnd = false
                self.wood = decodedData.results
                self.length = self.wood.count
                self.setQuestion()
            }
        } catch {
            print("Error fetching Wood: \(error)")
        }
    }
    
    // Fetch random questions (mix)
    func fetchWoodMix() async {
        do {
            let decodedData = try await apiService.fetchWoodMix()
            
            Task { @MainActor in
                self.index = 0
                self.score = 0
                self.progress = 0.00
                self.reachedEnd = false
                self.wood = decodedData.results
                self.length = self.wood.count
                self.setQuestion()
            }
        } catch {
            print("Error fetching random Wood: \(error)")
        }
    }
    
    // Set a new question
    func setQuestion() {
        answerSelected = false
        progress = CGFloat(Double(index + 1) / Double(length) * 350)
        
        if index < length {
            let currentWoodQuestion = wood[index]
            question = currentWoodQuestion.formatedQuestion
            answerChoices = currentWoodQuestion.answers
            currentDifficulty = currentWoodQuestion.difficulty.capitalized
            currentCategory = currentWoodQuestion.category
        }
    }
    
    // To call when selecting difficulty or category
    func updateGameSettings(category: String, difficulty: String) {
        selectedCategory = category
        selectedDifficulty = difficulty
        
        // Reload questions based on selected settings
        Task {
            await fetchWood(category: category, difficulty: difficulty)
        }
    }
    
    // Go to next question
    func goToNextQuestion() {
        if index + 1 < length {
            index += 1
            setQuestion()
            showCorrectAnswer = false
        } else {
            reachedEnd = true
        }
    }
    
    func selectAnswer(answer: Answer) {
        answerSelected = true
        if answer.isCorrect {
            score += 1
        }
    }
}
