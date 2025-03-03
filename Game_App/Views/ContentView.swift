//
//  ContentView.swift
//  Game_App
//
//  Created by Сергей Саченко on 12.02.2025.
//

import SwiftUI
import DotLottie

struct ContentView: View {
    @StateObject private var woodManager = WoodManager()
    @State private var showText = false
    @State private var showButton = false
    @AppStorage("log_status") private var logStatus: Bool = false
    
    var body: some View {
        
        if logStatus {
            // Home View
            ContentView()
        } else {
            LoginView()
        }
        
        NavigationStack {
            ZStack {
                Image("WoodImage")
                    .resizable()
                NavigationLink {
                    DifficultySelectionView()
                        .environmentObject(woodManager)
                } label: {
                    
                    DotLottieAnimation(fileName: "start", config: AnimationConfig(autoplay: true, loop: true))
                        .view()
                        .frame(width: 220, height: 220)
                        .offset(y: -30)
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
