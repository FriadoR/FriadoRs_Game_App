//
//  ApiService.swift
//  Wood Game
//
//  Created by Сергей Саченко on 24.02.2025.
//

import Foundation

class APIService {
    
    // Fetch questions based on category and difficulty
    func fetchWood(category: String, difficulty: String) async throws -> Wood {
        guard let url = URL(string: "https://opentdb.com/api.php?amount=10&category=\(category)&difficulty=\(difficulty)") else {
            throw URLError(.badURL)
        }
        
        let urlRequest = URLRequest(url: url)
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let decodedData = try decoder.decode(Wood.self, from: data)
        
        return decodedData
    }
    
    // Fetch random questions (mix)
    func fetchWoodMix() async throws -> Wood {
        guard let url = URL(string: "https://opentdb.com/api.php?amount=10") else {
            throw URLError(.badURL)
        }
        
        let urlRequest = URLRequest(url: url)
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let decodedData = try decoder.decode(Wood.self, from: data)
        
        return decodedData
    }
}

