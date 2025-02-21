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
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image("WoodImage")
                    .resizable()
                NavigationLink {
                    LottieView()
                        .environmentObject(woodManager)
                } label: {
                    
                    DotLottieAnimation(fileName: "start", config: AnimationConfig(autoplay: true, loop: true))
                        .view()
                        .frame(width: 220, height: 220)
                        .offset(y: -30)
//                    PrimaryButton(text: "Start Game")
//                        .opacity(showButton ? 1 : 0)
//                        .animation(.easeInOut(duration: 6), value: showButton)
//                        .padding(.bottom, 110)
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
