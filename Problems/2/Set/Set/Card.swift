//
//  Card.swift
//  Set
//
//  Created by Marton Zeisler on 2018. 11. 02..
//  Copyright © 2018. marton. All rights reserved.
//

import Foundation

struct Card: Equatable {
    
    var number: Int
    var symbol: Int
    var shading: Int
    var color: Int
    
    
    
    
    static func generateRandom81Cards() ->[Card]{
        var cards = [Card]()
        for each1 in 0...2{
            for each2 in 0...2{
                for each3 in 0...2{
                    for each4 in 0...2{
                        //cards.append(Card(number: each1, symbol: each2, shading: each3, color: each4))
                        cards.append(Card(number: 0, symbol: 0, shading: 0, color: 0))
                    }
                }
            }
        }
        return cards.shuffled()
    }
    
}

/*
 
 number - one(0), two(1), three(2)
 symbol - diamond(0), squiggle(1), oval(2)
 shaing - solid(0), striped(1), open(2)
 color  - red(0), green(1), purple(2)

 */

