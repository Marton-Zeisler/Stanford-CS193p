//
//  Concentration.swift
//  Concentration
//
//  Created by Marton Zeisler on 2018. 10. 21..
//  Copyright © 2018. marton. All rights reserved.
//

import Foundation

class Concentration{
    
    var cards = [Card]()
    
    var indexOfOneAndOnlyFaceUpCard: Int? // The index of the card which is currently faced up
    
    var flipCount = 0
    var score = 0.0
    var lastFlippedTime: Date!
    
    // 1. No cards are face up, just flip ove
    // 2. Two cards are face up, flip both cards down when choosing a new one
    // 3. One card is face up, and choose a card, need to check if they match
    func chooseCard(at index: Int){
        if !cards[index].isMatched{
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index{ // now we have 2 cards on the screen
                // check if cards match
                if cards[matchIndex].identifier == cards[index].identifier{ // the two cards match
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                    
                    let now = Date()
                    let pastTime = now.timeIntervalSince(lastFlippedTime)
                    let newScore: Double = 5 - (Double(pastTime)/10 * 5)
                    score = newScore >= 0 ? score + newScore : score
                    lastFlippedTime = Date()
                    
                }else{
                    checkSeenBefore(identifier: cards[index].identifier, secondIdentifier: cards[matchIndex].identifier)
                }
                
                cards[index].isFaceUp = true
                indexOfOneAndOnlyFaceUpCard = nil
            }else{
                // either no cards or 2 cards are face up
                
                for flipDownIndex in cards.indices{
                    cards[flipDownIndex].isFaceUp = false
                }
                cards[index].isFaceUp = true
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
    }
    
    func checkSeenBefore(identifier: Int, secondIdentifier: Int){ // when two different items are - mismatched
        var penalty = false
        for each in cards.indices{
            if cards[each].identifier == identifier || cards[each].identifier == secondIdentifier{
                if cards[each].isSeen{
                    penalty = true
                }
                cards[each].isSeen = true
            }
        }
        
        if penalty{
            score -= 1
        }
    }
    
    init(numberOfPairsOfCards: Int) {
        for _ in 0..<numberOfPairsOfCards{
            let card = Card()
            cards += [card, card]
        }
        
        cards.shuffle()
        lastFlippedTime = Date()
    }
    
    
}


// football, ski, tennis, ice-hockey, pool, skating,
