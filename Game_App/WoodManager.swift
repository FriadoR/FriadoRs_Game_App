//
//  WoodManager.swift
//  Wood Game
//
//  Created by Сергей Саченко on 14.02.2025.
//

import Foundation

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
    
    init() {
        Task.init {
            await fetchWood()
        }
    }
    
    func fetchWood() async {
        guard let url = URL(string: "https://opentdb.com/api.php?amount=10") else { fatalError( "Invalid URL") }
        
        let urlRequest = URLRequest(url: url)
        
        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            
            guard (response as? HTTPURLResponse)?.statusCode ?? 0 == 200 else { fatalError("Invalid HTTP response") }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let decodedData = try decoder.decode(Wood.self, from: data)
            
            DispatchQueue.main.async {
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
    
    func goToNextQuestion() {
        if index + 1 < length {
            index += 1
            setQuestion()
            showCorrectAnswer = false
        } else {
            reachedEnd = true
        }
    }
    
    func setQuestion() {
        answerSelected = false
        progress = CGFloat(Double(index + 1) / Double(length) * 350)
        
        if index < length {
            let currentWoodQuestion = wood[index]
            question = currentWoodQuestion.formatedQuestion
            answerChoices = currentWoodQuestion.answers
            
        }
    }
    func selectAnswer(answer: Answer) {
        answerSelected = true
        
        if answer.isCorrect {
            score += 1
        } else {
            showCorrectAnswer = false
        }
    }
}
