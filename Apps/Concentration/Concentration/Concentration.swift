//
//  Concentration.swift
//  Concentration
//
//  Created by Marton Zeisler on 2018. 10. 21..
//  Copyright © 2018. marton. All rights reserved.
//

import Foundation

struct Concentration{
    
    private(set) var cards = [Card]()
    
    private var indexOfOneAndOnlyFaceUpCard: Int? { // The index of the card which is currently faced up
        get{
            return cards.indices.filter { cards[$0].isFaceUp }.oneAndOnly // if it has one item in it, then we only have one card up faced up
        }set{
            for index in cards.indices{
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    // 1. No cards are face up, just flip ove
    // 2. Two cards are face up, flip both cards down when choosing a new one
    // 3. One card is face up, and choose a card, need to check if they match
    mutating func chooseCard(at index: Int){
        assert(cards.indices.contains(index), "Concentration.chooseCard(at: \(index)): chosen index not in the cards")
        if !cards[index].isMatched{
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index{
                // check if cards match
                if cards[matchIndex] == cards[index]{
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                }
                cards[index].isFaceUp = true
            }else{
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
    }
    
    init(numberOfPairsOfCards: Int) {
        assert(numberOfPairsOfCards > 0, "numberOfPairsOfCards(\(numberOfPairsOfCards)): you must have at least one pair of cards")
        for _ in 0..<numberOfPairsOfCards{
            let card = Card()
            cards += [card, card]
        }
        
        // TODO: Shuffle the cards
        
    }
}


extension Collection{
    var oneAndOnly: Element?{
        return count == 1 ? first : nil // if count of a collection is one then the collection has only one element
    }
}
