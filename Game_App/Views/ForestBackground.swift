//
//  ForestBackground.swift
//  Wood Game
//
//  Created by Сергей Саченко on 14.02.2025.
//

import SwiftUI

struct ForestBackgroundView: View {
    @State private var cloudOffset1: CGFloat = -1.5
    @State private var cloudOffset2: CGFloat = -1.0

    let cloudImage = "cloud.fill" // SF symbol cloud
    
    var body: some View {
        VStack {
            // main sun
            SunView()
            
            // two clouds
            cloudAnimationView(offset: $cloudOffset1, speed: 35)
                .zIndex(0)
            cloudAnimationView(offset: $cloudOffset2, speed: 20)
                .zIndex(0)
        }
        .background(
            Color(red: 38/255, green: 92/255, blue: 75/255)
                .ignoresSafeArea()
        )
    }
    
    // function animation cloud
    func cloudAnimationView(offset: Binding<CGFloat>, speed: Double) -> some View {
        Image(systemName: cloudImage)
            .resizable()
            .scaledToFit()
            .frame(width: 150, height: 100)
            .foregroundColor(.white.opacity(0.6))
            .offset(x: offset.wrappedValue * 300, y: -600)
            .onAppear {
                withAnimation(
                    Animation.linear(duration: speed)
                        .repeatForever(autoreverses: false)
                        .delay(0.5)
                ) {
                    offset.wrappedValue = 2.0
                }
            }
    }
    
    // function create sun
    func SunView() -> some View {
        Circle()
            .fill(Color.yellow)
            .frame(width: 120, height: 120)
            .position(x: 300, y: 60)
            .shadow(radius: 10)
    }
}
#Preview {
    ForestBackgroundView()
}

