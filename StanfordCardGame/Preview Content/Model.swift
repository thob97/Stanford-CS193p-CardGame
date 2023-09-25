//
//  Model.swift
//  StanfordCardGame
//
//  Created by Thore Brehmer on 24.09.23.
//

import Foundation

struct Model<CardContend> where CardContend: Equatable{
    //MARK: - Properties
    private(set) var cards: Array<Card>
    
    //MARK: - Init
    init(numberOfPairsOfCards: Int, contentFactory: (Int) -> CardContend) {
        cards = []
        for index in 0...numberOfPairsOfCards{
            let content = contentFactory(index)
            cards.append(Card(content: content))
            cards.append(Card(content: content))
        }
    }
    
    //MARK: - Functions
    var indexOfOnlyFaceUpCard: Int? {
        //returns first face up card
        get {cards.indices.filter{cards[$0].isFaceUp}.only}
        //facedown all cards + faceup new card
        set {cards.indices.forEach{cards[$0].isFaceUp = ($0 == newValue)} }
    }
    
    mutating func choose(_ card: Card){
        if let chosenIndex = cards.firstIndex(of: card) {
            //game logic
            if !cards[chosenIndex].isFaceUp && !cards[chosenIndex].isMatched {
                //there is one face up card
                if let faceUpCardIndex = indexOfOnlyFaceUpCard {
                    //match
                    if cards[chosenIndex].content == cards[faceUpCardIndex].content {
                        cards[chosenIndex].isMatched = true
                        cards[faceUpCardIndex].isMatched = true
                    }
                } else {
                    indexOfOnlyFaceUpCard = chosenIndex
                }
                //first face up card
                cards[chosenIndex].isFaceUp = true
                
            }
        }
    }
    
    mutating func shuffle(){cards.shuffle()}
    
    struct Card: Identifiable, Equatable, CustomDebugStringConvertible {
        let id = UUID().uuidString
        var isFaceUp = false
        var isMatched = false
        let content: CardContend
        
        var debugDescription: String {
            "custom description for debugging"
        }
        
//        static func == (lhs: Card, rhs: Card) -> Bool {
//            return lhs.id == rhs.id && lhs.content == rhs.content
//        }
    }
}

extension Array {
    var only: Element? {count == 1 ? first : nil}
}
