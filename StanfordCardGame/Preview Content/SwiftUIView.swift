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
        AspectVGrid(viewModel.cards, cardAspectRatio: cardAspectRatio) { card in
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

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView(viewModel: ViewModel())
        //MemoryCard(isFaceUp: false, content: "🐱")
    }
}
