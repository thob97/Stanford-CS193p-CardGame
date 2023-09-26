//
//  MemoryCard.swift
//  StanfordCardGame
//
//  Created by Thore Brehmer on 26.09.23.
//

import SwiftUI

struct MemoryCard: View {
    let card: Model<String>.Card
    
    init(_ card: Model<String>.Card) {
        self.card = card
    }
    
    private struct Constants {
        static let cardColor = Color.orange
        static let cornerRadius: CGFloat = 10
        static let lineWidth: CGFloat = 4
        struct Font {
            static let biggest: CGFloat = 200
            static let smallest: CGFloat = 10
            static let scaleFactor = smallest / biggest
        }
    }
    
    var body: some View{
        ZStack {
            //background
            if !card.isMatched {
                RoundedRectangle(cornerRadius: Constants.cornerRadius)
                    .fill(card.isFaceUp ? .white : Constants.cardColor)
            }
            //border
            if card.isFaceUp {
                RoundedRectangle(cornerRadius: Constants.cornerRadius)
                    .stroke(style: StrokeStyle(lineWidth: Constants.lineWidth))
                    .fill(Constants.cardColor)
                
                //item
                Text(card.content)
                //scale text to maxFit
                    .font(.system(size: Constants.Font.biggest))
                    .minimumScaleFactor(Constants.Font.scaleFactor) //if font is to big, scale it down
                    .aspectRatio(1, contentMode: .fit)
            }
        }
    }
}

struct MemoryCard_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            HStack {
                MemoryCard(Model<String>.Card(isFaceUp: true, isMatched: false, content: "X"))
                MemoryCard(Model<String>.Card(isFaceUp: false, isMatched: false, content: "X"))
            }
            HStack {
                MemoryCard(Model<String>.Card(isFaceUp: true, isMatched: true, content: "X"))
                MemoryCard(Model<String>.Card(isFaceUp: false, isMatched: true, content: "X"))
            }
            HStack {
                MemoryCard(Model<String>.Card(isFaceUp: true, isMatched: false, content: "This is a really long text and i want to know how it might look"))
                MemoryCard(Model<String>.Card(isFaceUp: true, isMatched: true, content: "This is a really long text and i want to know how it might look"))
                
            }
        }
    }
}
