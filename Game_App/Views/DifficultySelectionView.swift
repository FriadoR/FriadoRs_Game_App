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
    @State private var selectedCategory = "11" // Default category ID
    @State private var showConfirmation = false
    @State private var selectedCategoryName = "Movies"
    @State private var showCategoryModal = false
    @State private var showDifficultySelection = true // Для скрытия сложности после выбора
    
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
                    // Select Difficulty section
                    if showDifficultySelection {
                        Text("Select Difficulty")
                            .font(.title)
                            .foregroundColor(.white)
                            .bold()
                            .frame(height: 80)
                        
                        VStack(spacing: 20) {
                            // Difficulty options
                            ForEach(["easy", "medium", "hard"], id: \.self) { difficulty in
                                VStack {
                                    Image(systemName: difficulty == "easy" ? "leaf.fill" : difficulty == "medium" ? "circle.fill" : "flame.fill")
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                        
                                        .foregroundColor(selectedDifficulty == difficulty ? .white : .yellow)
                                        
                                        .padding()
                                        .background(selectedDifficulty == difficulty ? Color.yellow : Color.gray.opacity(0.2))
                                        .cornerRadius(12)
                                        .shadow(radius: 5)
                                    
                                    Text(difficulty.capitalized)
                                        .fontWeight(.semibold)
                                        .foregroundColor(selectedDifficulty == difficulty ? .white : .yellow)
                                }
                                .frame(width: 170, height: 130) // Сделали прямоугольными и увеличили ширину
                                .background(selectedDifficulty == difficulty ? Color.yellow : Color.gray.opacity(0.1))
                                .cornerRadius(15)
                                .onTapGesture {
                                    selectedDifficulty = difficulty
                                    showCategoryModal = true // Показываем модальное окно для категорий
                                    withAnimation { showDifficultySelection = false } // Скрыть сложности
                                }
                            }
                            
                            // Mix option
                            VStack {
                                Image(systemName: "shuffle")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(selectedDifficulty == "mix" ? .white : .yellow)
                                    .padding()
                                    .background(selectedDifficulty == "mix" ? Color.yellow : Color.gray.opacity(0.2))
                                    .cornerRadius(12)
                                    .shadow(radius: 5)
                                
                                Text("Mix")
                                    .fontWeight(.semibold)
                                    .foregroundColor(selectedDifficulty == "mix" ? .white : .yellow)
                            }
                            .frame(width: 150, height: 150) // Прямоугольная кнопка Mix
                            .background(selectedDifficulty == "mix" ? Color.blue : Color.gray.opacity(0.1))
                            .cornerRadius(12)
                            .onTapGesture {
                                selectedDifficulty = "mix"
                                // Здесь можно добавить логику для микса вопросов
                                showCategoryModal = true // Показываем модальное окно для категорий
                                withAnimation { showDifficultySelection = false } // Скрыть сложности
                            }
                        }
                        .padding()

                    }
                    
                    // Confirmation Dialog
                    if showConfirmation {
                        VStack {
                            Text("You selected \(selectedCategoryName) with \(selectedDifficulty) difficulty")
                                .font(.title2)
                                .foregroundColor(.blue)
                                .padding()
                            
                            HStack {
                                // Убираем onTapGesture, используй чисто NavigationLink
                                NavigationLink {
                                    LottieView()
                                        .environmentObject(woodManager)
                                } label: {
                                    Text("Start Quiz")
                                        .padding()
                                        .background(Color.blue)
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                        .shadow(radius: 5)
                                        .onAppear {
                                            // Debug: Выводим информацию о категории перед запросом
                                            print("Starting quiz with category: \(selectedCategoryName), ID: \(selectedCategory), Difficulty: \(selectedDifficulty)")
                                            
                                            // Запускаем загрузку с правильной категорией
                                            Task {
                                                await woodManager.fetchWood(category: selectedCategory, difficulty: selectedDifficulty)
                                            }
                                        }
                                }
                                
                                Button(action: {
                                    showConfirmation = false
                                    withAnimation { showDifficultySelection = true }
                                }) {
                                    Text("Cancel")
                                        .padding()
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
                        .cornerRadius(10)
                        .shadow(radius: 10)
                    }
                }
                
                // Custom Modal for selecting category
                if showCategoryModal {
                    VStack {
                        Spacer()
                        
                        ZStack {
                            // Градиентный фон с теплой желтой темой
                            LinearGradient(gradient: Gradient(colors: [Color.orange.opacity(0.7), Color.yellow.opacity(0.7)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                                .edgesIgnoringSafeArea(.all)
                                .cornerRadius(10)
                            
                            VStack {
                                Text("Select Category")
                                    .font(.title)
                                    .foregroundColor(.white) // Цвет текста
                                    .padding()
                                    .background(
                                        LinearGradient(gradient: Gradient(colors: [Color.yellow, Color.orange]), startPoint: .topLeading, endPoint: .bottomTrailing)
                                    ) // Градиентный фон для текста
                                    .cornerRadius(10) // Округленные углы для красивого эффекта
                                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 4) // Тень для текста
                                
                                
                                // Используем LazyVGrid для отображения категорий по 3 штуки в ряд
                                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                                    ForEach(categories.keys.sorted(), id: \.self) { category in
                                        Button(action: {
                                            selectedCategory = categories[category]! // Получаем ID категории
                                            selectedCategoryName = category
                                            showConfirmation = true
                                            withAnimation { showCategoryModal = false }
                                        }) {
                                            Text(category)
                                                .font(.headline) // Увеличиваем шрифт для лучшей читаемости
                                                .padding()
                                                .background(
                                                    LinearGradient(gradient: Gradient(colors: [Color.yellow, Color.orange]), startPoint: .topLeading, endPoint: .bottomTrailing)
                                                ) // Градиент для кнопки
                                                .foregroundColor(.white)
                                                .cornerRadius(10)
                                                .frame(minWidth: 120, minHeight: 60) // Увеличиваем размер кнопок, чтобы текст не выходил
                                                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 4) // Тень для кнопок
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
                                        .frame(minWidth: 120, minHeight: 60) // Такой же размер, как у других кнопок
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
        }
    }
}



#Preview {
    DifficultySelectionView()
        .environmentObject(WoodManager())
}
