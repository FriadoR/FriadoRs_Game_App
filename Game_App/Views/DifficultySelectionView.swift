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
    @State private var showConfirmation = false
    @State private var selectedCategoryName = "Movies"
    @State private var showCategoryModal = false
    @State private var showDifficultySelection = true
    @State private var isMixSelected = false
    
    let categories = [
        "Books": "15",
        "Movies": "11",
        "Music": "12",
        "Video Games": "14",
        "History": "23",
        "Sports": "21",
        "Cars": "28",
        "Animals": "27"
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
                                showConfirmation = true
                                showDifficultySelection = false
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
                            Text(isMixSelected ? "You selected Mix with random questions" : "You selected \(selectedDifficulty.capitalized) difficulty and \(selectedCategoryName) category")
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
                        .background(Color.white)
                        .cornerRadius(15)
                        .shadow(radius: 10)
                    }
                }
                
                // Custom Modal for selecting category (only for non-Mix selection)
                if showCategoryModal {
                    VStack {
                        Spacer()
                        
                        ZStack {
                            LinearGradient.warmYellowGradient()
                                .edgesIgnoringSafeArea(.all)
                                .cornerRadius(10)
                            
                            VStack {
                                Text("Select Category")
                                    .font(.title)
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(LinearGradient.categoryButtonGradient())
                                    .cornerRadius(10)
                                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 4)
                                
                                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                                    ForEach(categories.keys.sorted(), id: \.self) { category in
                                        Button(action: {
                                            selectedCategory = categories[category]! // Taken ID category
                                            selectedCategoryName = category
                                            showConfirmation = true
                                            withAnimation { showCategoryModal = false }
                                        }) {
                                            Text(category)
                                                .font(.headline)
                                                .padding()
                                                .background(LinearGradient.categoryButtonGradient())
                                                .foregroundColor(.white)
                                                .cornerRadius(10)
                                                .frame(minWidth: 120, minHeight: 60)
                                                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 4)
                                        }
                                        .padding(.bottom, 10)
                                    }
                                }
                                .padding()
                                
                                Button(action: {
                                    withAnimation { showCategoryModal = false }
                                    withAnimation { showDifficultySelection = true }
                                }) {
                                    Text("Cancel")
                                        .padding()
                                        .background(Color.gray)
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                        .frame(minWidth: 120, minHeight: 60)
                                        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 4)
                                }
                                .padding(.top, 10)
                            }
                            .padding()
                        }
                        .frame(width: 350, height: 590)
                        .cornerRadius(20)
                        .transition(.move(edge: .bottom))
                    }
                    .frame(width: 350, height: 550)
                    .background(Color.black.opacity(0.4).edgesIgnoringSafeArea(.all))
                    .transition(.opacity)
                    .cornerRadius(20)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea(.all)
            .woodBackground()
            .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    DifficultySelectionView()
        .environmentObject(WoodManager())
}
