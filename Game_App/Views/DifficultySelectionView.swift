//
//  DifficultySelectionView.swift
//  Wood Game
//
//  Created by Сергей Саченко on 22.02.2025.
//

import SwiftUI

struct DifficultySelectionView: View {
    @EnvironmentObject var woodManager: WoodManager
    @State private var selectedDifficulty = "easy"
    @State private var selectedCategory = "11"
    @State private var selectedCategoryName = "Movies"
    @State private var showCategoryModal = false
    @State private var showDifficultySelection = true
    @State private var isMixSelected = false
    @State private var showConfirmation = false
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @GestureState private var dragOffset = CGSize.zero
    
    let categories = [
        "Books": "15",
        "Movies": "11",
        "Music": "12",
        "Video Games": "14",
        "History": "23",
        "Sports": "21",
        "Cars": "28",
        "Animals": "27",
        "Geography": "22"
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    if showDifficultySelection && !isMixSelected {
                        Text("Select Difficulty")
                            .font(.title)
                            .foregroundColor(.white)
                            .bold()
                            .frame(height: 80)
                        
                        VStack(spacing: 20) {
                            ForEach(["easy", "medium", "hard"], id: \.self) { difficulty in
                                Button(action: {
                                    selectedDifficulty = difficulty
                                    showCategoryModal = true
                                    withAnimation { showDifficultySelection = false }
                                }) {
                                    VStack {
                                        Image(systemName: difficulty == "easy" ? "leaf.fill" : difficulty == "medium" ? "circle.fill" : "flame.fill")
                                            .resizable()
                                            .frame(width: 40, height: 40)
                                            .foregroundColor(.white)
                                            .padding()
                                        
                                        Text(difficulty.capitalized)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.white)
                                    }
                                    .frame(width: 170, height: 130)
                                    .background(
                                        difficulty == "easy" ? Color.green :
                                            difficulty == "medium" ? Color.orange :
                                            Color.red
                                    )
                                    .cornerRadius(15)
                                    .shadow(radius: 5)
                                }
                            }
                            
                            // Mix option (without category selection)
                            Button(action: {
                                isMixSelected = true
                                showCategoryModal = false
                                showDifficultySelection = false
                                showConfirmation = true
                            }) {
                                VStack {
                                    Image(systemName: "shuffle")
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                        .foregroundColor(.white)
                                        .padding()
                                    
                                    Text("Mix")
                                        .fontWeight(.semibold)
                                        .foregroundColor(.white)
                                }
                                .frame(width: 170, height: 130)
                                .background(Color.blue)
                                .cornerRadius(15)
                                .shadow(radius: 5)
                            }
                        }
                        .padding()
                    }
                    
                    // Confirmation Dialog for both Mix and selected difficulty + category
                    if showConfirmation {
                        VStack {
                            Text(isMixSelected ? "You selected Mix with random questions" : "You selected \(selectedDifficulty.capitalized) and \(selectedCategoryName) category")
                                .font(.title2)
                                .foregroundColor(.textWood)
                                .padding()
                            
                            HStack {
                                // Start the game with selected difficulty and category (or mix)
                                NavigationLink {
                                    LottieView()
                                        .environmentObject(woodManager)
                                } label: {
                                    Text("Start")
                                        .frame(width: 150, height: 50)
                                        .background(Color.green)
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                        .shadow(radius: 5)
                                        .onAppear {
                                            // Debug: Logging information
                                            if isMixSelected {
                                                print("Starting game with random questions (Mix)")
                                                Task {
                                                    await woodManager.fetchWoodMix() // Start loading random questions
                                                }
                                            } else {
                                                print("Starting game with \(selectedDifficulty) difficulty and \(selectedCategoryName) category")
                                                Task {
                                                    await woodManager.fetchWood(category: selectedCategory, difficulty: selectedDifficulty)
                                                }
                                            }
                                        }
                                }
                                
                                Button(action: {
                                    // Reset the state and go back to the difficulty selection
                                    showConfirmation = false
                                    if isMixSelected {
                                        // Reset for Mix and go back to difficulty selection
                                        isMixSelected = false
                                        withAnimation { showDifficultySelection = true }
                                    } else {
                                        withAnimation { showCategoryModal = true }
                                    }
                                }) {
                                    Text("Cancel")
                                        .frame(width: 150, height: 50)
                                        .background(Color.gray)
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                        .shadow(radius: 5)
                                }
                            }
                        }
                        .frame(width: 300)
                        .padding()
                        .background(LinearGradient.categoryButtonGradient())
                        .cornerRadius(15)
                        .shadow(radius: 10)
                    }
                }
                
                // Modal for selecting category
                if showCategoryModal {
                    VStack {
                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(categories.keys.sorted(), id: \.self) { category in
                                    Circle()
                                        .frame(width: 350, height: 300)
                                        .overlay(
                                            Text(category)
                                                .foregroundColor(.white)
                                                .font(.headline)
                                                .padding()
                                        )
                                        .foregroundStyle(LinearGradient(colors: [.yellow, .red], startPoint: .top, endPoint: .bottom))
                                        .padding(.horizontal, 16)
                                        .onTapGesture {
                                            selectedCategory = categories[category]!
                                            selectedCategoryName = category
                                            // When a category is selected, show the confirmation screen
                                            withAnimation {
                                                showCategoryModal = false
                                                showConfirmation = true
                                            }
                                        }
                                        .containerRelativeFrame(.horizontal, count: verticalSizeClass == .regular ? 1 : 4, spacing: 16)
                                        .scrollTransition { content, phase in
                                            content
                                                .opacity(phase.isIdentity ? 1.0 : 0.0)
                                                .scaleEffect(x: phase.isIdentity ? 1.0 : 0.3, y: phase.isIdentity ? 1.0 : 0.3)
                                                .offset(y: phase.isIdentity ? 0 : 50)
                                        }
                                }
                            }
                        }
                        .padding()
                    }
                    .transition(.opacity)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(LinearGradient.warmYellowGradient())
            .ignoresSafeArea(.all)
            .navigationBarBackButtonHidden(true)
            // Add the tap gesture to dismiss the ScrollView when tapping outside
            .onTapGesture {
                if showCategoryModal {
                    withAnimation {
                        showCategoryModal = false
                        showDifficultySelection = true
                    }
                }
            }
        }
    }
}

#Preview {
    DifficultySelectionView()
        .environmentObject(WoodManager())
}

