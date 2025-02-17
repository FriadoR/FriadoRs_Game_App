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
    
    init() {
        Task.init {
            await fetchWood()
        }
    }
    
    func fetchWood() async {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else { fatalError( "Invalid URL") }
        
        let urlRequest = URLRequest(url: url)
        
        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            
            guard (response as? HTTPURLResponse)?.statusCode ?? 0 == 200 else { fatalError("Invalid HTTP response") }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let decodedData = try decoder.decode(Wood.self, from: data)
            
            DispatchQueue.main.async {
                self.wood = decodedData.results
                self.length = self.wood.count
            }
            
        } catch {
            print("Error fetching Wood: \(error)")
        }
    }
    
    func goToNextQuestion() {
        if index + 1 < length {
            index += 1
        } else {
            reachedEnd = true
        }
    }
}
