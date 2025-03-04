//
//  Extensions.swift
//  Game_App
//
//  Created by Сергей Саченко on 12.02.2025.
//

import Foundation
import SwiftUI

extension Text {
    func customTitle() -> some View {
        self .font(.title)
            .fontWeight(.heavy)
            .foregroundColor(.textWood)
    }
}
extension View {
    func customTitle() -> some View {
        self
            .font(.title)
            .fontWeight(.heavy)
            .foregroundColor(.textWood)
    }
}
extension View {
    func woodBackground() -> some View {
        self.background(
            LinearGradient(gradient: Gradient(colors: [Color("DACCB0"), Color("B9A888")]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
        )
    }
}

extension LinearGradient {
    static func warmYellowGradient() -> LinearGradient {
        return LinearGradient(gradient: Gradient(colors: [Color.orange.opacity(0.7), Color.yellow.opacity(0.7)]), startPoint: .topLeading, endPoint: .bottomTrailing)
    }
    
    static func categoryButtonGradient() -> LinearGradient {
        return LinearGradient(gradient: Gradient(colors: [Color.yellow, Color.orange]), startPoint: .topLeading, endPoint: .bottomTrailing)
    }
    
    static func mainLoginCutomGradient() -> LinearGradient {
        return LinearGradient(gradient: Gradient(colors: [.blue, .purple]), startPoint: .topLeading, endPoint: .bottomTrailing)
    }
}

