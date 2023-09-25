//
//  SwiftUIView.swift
//  StanfordCardGame
//
//  Created by Thore Brehmer on 24.09.23.
//

import SwiftUI

struct SwiftUIView: View {
    @ObservedObject var viewModel: ViewModel
    
    private let cardAspectRatio: CGFloat = 2/3

    var body: some View {
        VStack {
            cards
            
            Button("Shuffel") {
                viewModel.shuffle()
            }
        }
    }
    
    @ViewBuilder
    private var cards: some View {
        GeometryReader { geometry in
            let gridItemSize = gridItemWidthThatFits(itemCount: viewModel.cards.count, spaceBoundaries: geometry.size, atAspectRatio: cardAspectRatio)
            LazyVGrid(columns: [GridItem(.adaptive(minimum: gridItemSize), spacing: 0)], spacing: 0) {
                ForEach(viewModel.cards) { card in
                    MemoryCard(card)
                        .aspectRatio(cardAspectRatio, contentMode: .fill)
                        .onTapGesture {
                            viewModel.choose(card)
                        }
                        .padding(8)
                        //animation only works with ForEach(cards), does not work with ForEach(indices), as the indices would always stay the same
                        .animation(.default, value: viewModel.cards)
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

struct MemoryCard: View {
    let card: Model<String>.Card
    
    init(_ card: Model<String>.Card) {
        self.card = card
    }
    
    let color = Color.orange
    
    var body: some View{
        ZStack {
            if !card.isMatched {
                RoundedRectangle(cornerRadius: 10)
                    .fill(card.isFaceUp ? .white : color)
                RoundedRectangle(cornerRadius: 10)
                    .stroke(style: StrokeStyle(lineWidth: 4))
                .fill(color)
            }
            if card.isFaceUp {
                Text(card.content)
                    //scale text to maxFit
                    .font(.system(size: 200))
                    .minimumScaleFactor(0.01) //if font is to big, scale it down
                    .aspectRatio(contentMode: .fit)
            }
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView(viewModel: ViewModel())
        //MemoryCard(isFaceUp: false, content: "🐱")
    }
}
