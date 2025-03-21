//
//  DifficultySelectionView.swift
//  Wood Game
//
//  Created by Сергей Саченко on 22.02.2025.
//

import SwiftUI

struct ImageModel: Identifiable {
    var id: String = UUID().uuidString
    var altText: String
    var image: String
    var categoryID: String
    
}

let images: [ImageModel] = [
    .init(altText: "Books", image: "books", categoryID: ""),
    .init(altText: "Movies", image: "movies", categoryID: ""),
    .init(altText: "Video Games", image: "video_games", categoryID: ""),
    .init(altText: "History", image: "history", categoryID: ""),
    .init(altText: "Sports", image: "sports", categoryID: ""),
    .init(altText: "Cars", image: "cars", categoryID: ""),
    .init(altText: "Animals", image: "animals", categoryID: ""),
    .init(altText: "Geography", image: "geography", categoryID: "")
]

struct DifficultySelectionView: View {
    @EnvironmentObject var woodManager: WoodManager
    @State internal var selectedDifficulty = "easy"
    @State internal var selectedCategory: String
    @State internal var selectedCategoryName: String
    @State internal var showCategoryModal = false
    @State internal var showDifficultySelection = true
    @State internal var isMixSelected = false
    @State internal var showConfirmation = false
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
    
    var combinedImages: [ImageModel] {
        images.compactMap { image in
            guard let categoryID = categories[image.altText] else { return nil }
            return ImageModel(altText: image.altText, image: image.image, categoryID: categoryID)
        }
    }
    
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
                if showCategoryModal {
                    NavigationStack {
                        VStack {
                            Text("Choose a category")
                                .font(.title)
                                .padding()
                                .foregroundStyle(.white)
                            LoopingStack {
                                ForEach(combinedImages) { image in
                                    Image(image.image)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 250, height: 400)
                                        .clipShape(.rect(cornerRadius: 30))
                                        .padding(5)
                                        .background {
                                            RoundedRectangle(cornerRadius: 35)
                                                .fill(.background)
                                        }
                                        .onTapGesture {
                                            selectedCategory = image.categoryID
                                            selectedCategoryName = image.altText
                                            withAnimation {
                                                showCategoryModal = false
                                                showConfirmation = true
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(LinearGradient.mainLoginCutomGradient())
            .ignoresSafeArea(.all)
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
    DifficultySelectionView(selectedCategory: "", selectedCategoryName: "")
        .environmentObject(WoodManager())
}

