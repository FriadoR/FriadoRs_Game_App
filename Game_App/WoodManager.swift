//
//  WoodManager.swift
//  Wood Game
//
//  Created by Сергей Саченко on 14.02.2025.
//

import Foundation

class WoodManager: ObservableObject {
    
    func fetchWood() {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else {
            fatalError( "Invalid URL")
        }
    }
}
