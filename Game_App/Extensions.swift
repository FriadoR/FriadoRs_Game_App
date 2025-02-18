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
            .foregroundColor(Color(.textWood))
    }
}
