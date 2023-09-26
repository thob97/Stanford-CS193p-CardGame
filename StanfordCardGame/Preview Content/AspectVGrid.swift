//
//  AspectVGrid.swift
//  StanfordCardGame
//
//  Created by Thore Brehmer on 26.09.23.
//

import SwiftUI

struct AspectVGrid<Item: Identifiable, ItemView: View>: View {
    var items: [Item]
    var cardAspectRatio: CGFloat
    @ViewBuilder var content: (Item) -> ItemView
    
    init(_ items: [Item], cardAspectRatio: CGFloat, @ViewBuilder content: @escaping (Item) -> ItemView) {
        self.items = items
        self.cardAspectRatio = cardAspectRatio
        self.content = content
    }
    
    var body: some View {
        GeometryReader { geometry in
            let gridItemSize = gridItemWidthThatFits(itemCount: items.count, spaceBoundaries: geometry.size, atAspectRatio: cardAspectRatio)
            LazyVGrid(columns: [GridItem(.adaptive(minimum: gridItemSize), spacing: 0)], spacing: 0) {
                ForEach(items) { item in
                    content(item)
                        .aspectRatio(cardAspectRatio, contentMode: .fit)
                }
            }
        }
    }
        //try to fit all items in 1 column, then in 2 columns, end if all of them fit into height
        private func gridItemWidthThatFits(
            itemCount: Int,
            spaceBoundaries: CGSize,
            atAspectRatio aspectRatio: CGFloat
        ) -> CGFloat {
            let itemCount = CGFloat(itemCount)
            var columnCount = 1.0
            while columnCount < itemCount {
                //get cell dimensions
                let cellWidth = spaceBoundaries.width / columnCount
                let cellHeight = cellWidth / aspectRatio
                let rowCount = (itemCount / columnCount).rounded(.up)
                
                //test if it fits in height boundaries
                if rowCount * cellHeight < spaceBoundaries.height {
                    return (spaceBoundaries.width / columnCount).rounded(.down)
                }
                //repeat and test with one more column for space
                columnCount += 1
            }
            //else take min width, height for cards
            return min(spaceBoundaries.width / itemCount, spaceBoundaries.height * aspectRatio).rounded(.down)
            
        }
        
    
}
