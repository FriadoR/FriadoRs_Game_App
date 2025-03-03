//
//  MainView.swift
//  Wood Game
//
//  Created by Сергей Саченко on 03.03.2025.
//

import SwiftUI

struct MainView: View {
    @AppStorage("log_status") private var logStatus: Bool = false
    
    var body: some View {
        if logStatus {
            ContentView()
        } else {
            LoginView()
        }
    }
}

#Preview {
    MainView()
}
