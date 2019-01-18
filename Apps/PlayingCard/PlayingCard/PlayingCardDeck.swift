//
//  PlayingCardDeck.swift
//  PlayingCard
//
//  Created by Marton Zeisler on 2018. 11. 22..
//  Copyright © 2018. marton. All rights reserved.
//

import Foundation

struct PlayingCardDeck{
    private(set) var cards = [PlayingCard]()
    
    init(){
        for suit in PlayingCard.Suit.all{
            for rank in PlayingCard.Rank.all{
                cards.append(PlayingCard(suit: suit, rank: rank))
            }
        }
    }
    
    mutating func draw() ->PlayingCard?{
        if cards.count > 0{
            return cards.remove(at: cards.count.arc4random)
        }else{
            return nil
        }
    }
}


extension Int{
    /// Generates a andom number and returns it
    var arc4random: Int{
        if self > 0{
            return Int(arc4random_uniform(UInt32(self)))
        }else if self < 0{
            return -Int(arc4random_uniform(UInt32(abs(self))))
        }else{
            return 0
        }
    }
}
