//
//  LoopingStack.swift
//  Wood Game
//
//  Created by Сергей Саченко on 06.03.2025.
//

import SwiftUI

struct LoopingStack<DifficultySelection: View>: View {
    var visibleCardsCount: Int = 2
    @ViewBuilder var content: DifficultySelection
    @State private var rotation: Int = 0
    
    var body: some View {
        /// Extract Subview collection from a view content with of help of Group (ios 18)
        Group(subviews: content) { collection in
            let collection = collection.rotateFromLeft(by: rotation)
            let count = collection.count
            
            ZStack {
                ForEach(collection) { view in
                    // Reverse with stack of index
                    let index = collection.index(view)
                    let zIndex = Double(count - index)
                    
                    LoopingStackCardView(index: index, count: count, visibleCardsCount: visibleCardsCount, rotation: $rotation) {
                        view
                    }
                    
                    .zIndex(zIndex)
                }
            }
        }
    }
}

fileprivate struct LoopingStackCardView<DifficultySelection: View>: View {
    var index: Int
    var count: Int
    var visibleCardsCount: Int
    @Binding var rotation: Int
    
    @ViewBuilder var content: DifficultySelection
    @State private var offset: CGFloat = .zero
    // when dragging is finished result (to push into next card)
    @State private var isFinishedDragging: CGSize = .zero
    
    var body: some View {
        
        // Visible Cards Offset and Scaling
        let extraOffset = min(CGFloat(index) * 20, CGFloat(visibleCardsCount) * 20)
        let scale = 1 - min(CGFloat(index) * 0.07, CGFloat(visibleCardsCount) * 0.07)
        
        // Some 3D rotation when swiping the card
        let rotationDegree: CGFloat = -30
        let rotation = max(min(-offset / isFinishedDragging.width, 1), 0) * rotationDegree
        
        content
            .onGeometryChange(for: CGSize.self, of: {
                $0.size
            }, action: {
                isFinishedDragging = $0
            })
            .offset(x: extraOffset)
            .scaleEffect(scale, anchor: .trailing)
        // animate the index effects
            .animation(.smooth(duration: 0.25, extraBounce: 0), value: index)
            .offset(x: offset)
            .rotation3DEffect(.init(degrees: rotation), axis: (0, 1, 0), anchor: .center, perspective: 0.5)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        // left side interaction
                        let xOffset = -max(-value.translation.width, 0)
                        offset = xOffset
                    }.onEnded { value in
                        let xVelocity = max(-value.velocity.width / 5, 0)
                        
                        if (-offset + xVelocity) > (isFinishedDragging.width * 0.65) {
                            pushToNextCard()
                        } else {
                            withAnimation(.smooth(duration: 0.3, extraBounce: 0)) {
                                offset = .zero
                            }
                        }
                    },
                // Only Activating Gesture for the top most card
                isEnabled: index == 0 && count > 1
            )
    }
    
    private func pushToNextCard() {
        withAnimation(.smooth(duration: 0.25, extraBounce: 0).logicallyComplete(after: 0.15),
                      completionCriteria: .logicallyComplete) {
            offset = -isFinishedDragging.width
        } completion: {
            // Once the card has been moved, update z-index and reset its offset value
            rotation += 1
            withAnimation(.smooth(duration: 0.25, extraBounce: 0)) {
                offset = .zero
            }
        }
    }
}

extension SubviewsCollection {
    // push cards behind, rotate the array to achieve that
    func rotateFromLeft(by: Int) -> [SubviewsCollection.Element] {
        let moveIndex = by % count
        let rotatedElements = Array(self[moveIndex...]) + Array(self[0..<moveIndex])
        return rotatedElements
    }
}
    
    extension [SubviewsCollection.Element] {
        func index(_ item: SubviewsCollection.Element) -> Int {
            firstIndex(where: { $0.id == item.id }) ?? 0
    }
}

#Preview {
    DifficultySelectionView(selectedCategory: "", selectedCategoryName: "")
}
