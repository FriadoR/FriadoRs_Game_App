//
//  WoodView.swift
//  Game_App
//
//  Created by Сергей Саченко on 13.02.2025.
//

import SwiftUI

struct WoodView: View {
    @EnvironmentObject var woodManager: WoodManager
    
    var body: some View {
        QuestionView()
            .environmentObject(woodManager)
    }
}

#Preview {
    WoodView()
        .environmentObject(WoodManager())
}
