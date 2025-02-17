//
//  ContentView.swift
//  Game_App
//
//  Created by Сергей Саченко on 12.02.2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var woodManager = WoodManager()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 40) {
                VStack(spacing: 20) {
                    
                    Text("Wood Game!")
                        .customTitle()
                    
                    Text("Are you ready to test your wood skills?!")
                        .font(.headline)
                        .foregroundColor(Color("AccentColor"))
                }
                
                NavigationLink {
                    WoodView()
                        .environmentObject(woodManager)
                } label: {
                    PrimaryButton(text: "Start Game!") }
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea(.all)
            .background(Color(red: 38/255, green: 92/255, blue: 75/255)) // Color(hex: "#265C4B")
        }
    }
}

#Preview {
    ContentView()
}
