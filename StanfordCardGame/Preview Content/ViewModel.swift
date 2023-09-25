//
//  ViewModel.swift
//  StanfordCardGame
//
//  Created by Thore Brehmer on 24.09.23.
//

import Foundation

class ViewModel: ObservableObject{
    //MARK: - Properties
    @Published private var model = Model(numberOfPairsOfCards: 12) {indexToContent in
        let emojis = ["🐶","🐱","🐭","🐹","🐰","🦊","🐻","🐼","🐻‍❄️","🐨","🐯","🦁"]
        //protection of to high numberOfPairs
        if emojis.count > indexToContent {
            return ["🐶","🐱","🐭","🐹","🐰","🦊","🐻","🐼","🐻‍❄️","🐨","🐯","🦁"][indexToContent]
        }
        else {
            return "❓"
        }
        
    }
    var cards: [Model<String>.Card] {model.cards}
    
    //MARK: - Init
    init() {}
    
    //MARK: - Functions
    func choose(_ card: Model<String>.Card) {model.choose(card)}
    
    func shuffle(){model.shuffle()}
}
