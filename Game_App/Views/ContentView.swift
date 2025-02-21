//
//  ContentView.swift
//  Game_App
//
//  Created by Сергей Саченко on 12.02.2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var woodManager = WoodManager()
    @State private var showText = false
    @State private var showButton = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image("WoodImage")
                    .resizable()
                NavigationLink {
                    WoodView()
                        .environmentObject(woodManager)
                } label: {
                    PrimaryButton(text: "Start Game")
                        .opacity(showButton ? 1 : 0)
                        .animation(.easeInOut(duration: 6), value: showButton)
                        .padding(.bottom, 110)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea(.all)
            .onAppear {
                withAnimation {
                    showButton = true
                }
            }.navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(WoodManager())
}
