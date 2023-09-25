//
//  SwiftUIView.swift
//  StanfordCardGame
//
//  Created by Thore Brehmer on 24.09.23.
//

import SwiftUI

struct SwiftUIView: View {
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        VStack {
            ScrollView {
                cards
            }
            Button("Shuffel") {
                viewModel.shuffle()
            }
        }
    }
    
    var cards: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 85), spacing: 0)], spacing: 0) {
            ForEach(viewModel.cards) { card in
                MemoryCard(card)
                    .aspectRatio(2/3, contentMode: .fill)
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
