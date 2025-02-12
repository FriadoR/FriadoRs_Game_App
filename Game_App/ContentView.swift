//
//  ContentView.swift
//  Game_App
//
//  Created by Сергей Саченко on 12.02.2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "cat.fill")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, Cat!")
                .font(.title)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
