//
//  ContentView.swift
//  Game_App
//
//  Created by Сергей Саченко on 12.02.2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 40) {
            VStack(spacing: 20) {
                
                Text("Wood Game!")
                    .font(.title)
                    .fontWeight(.heavy)
                    .foregroundColor(Color("AccentColor"))
                
                Text("Are you ready to test your wood skills?!")
                    .font(.headline)
                    .foregroundColor(Color("AccentColor"))
            }
            PrimaryButton(text: "Start Game!")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea(.all)
        .background(Color(red: 38/255, green: 92/255, blue: 75/255)) // Color(hex: "#265C4B")
    }
}

#Preview {
    ContentView()
}
