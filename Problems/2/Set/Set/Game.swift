//
//  Game.swift
//  Set
//
//  Created by Marton Zeisler on 2018. 11. 09..
//  Copyright © 2018. marton. All rights reserved.
//

import Foundation

class Game{
    private var random81Cards: [Card]!
    private var dealCounter: Int! // next card to take from the random81Cards
    private(set) var userCards: [Card]! // list of 24 cards
    private(set) var score: Int!
    weak var gameDelegate: gameDelegate?
    
    init() {
        startNew()
    }
    
    func startNew(){
        random81Cards = Card.generateRandom81Cards()
        userCards = Array(random81Cards[0..<12])
        score = 0
        dealCounter = 12
    }
    
    func mismatched(){
        score -= 5
        gameDelegate?.mismatched()
        
        if score < 0 {
            lost()
        }
    }
    
    func matched(card1: Card, card2: Card, card3: Card){
        userCards.remove(at: userCards.index(of: card1)!)
        userCards.remove(at: userCards.index(of: card2)!)
        userCards.remove(at: userCards.index(of: card3)!)
        
        score += 1
        
        if userCards.isEmpty{
            won()
        }else{
            load3More()
            gameDelegate?.matched()
        }
    }
    
    func won(){ // make this a delegate call
        gameDelegate?.gameWon()
    }
    
    func lost(){
        gameDelegate?.gameLost()
    }
    
    func load3More(){
        var counter = 0
        while userCards.count < 24 && counter < 3 && dealCounter < random81Cards.count{
            print("Adding a card...")
            userCards.append(random81Cards[dealCounter])
            dealCounter += 1
            counter += 1
        }
    }
    
    func attemptMatch(index1: Int, index2: Int, index3: Int){
        let number1 = userCards[index1].number
        let number2 = userCards[index2].number
        let number3 = userCards[index3].number
        
        let symbol1 = userCards[index1].symbol
        let symbol2 = userCards[index2].symbol
        let symbol3 = userCards[index3].symbol
        
        let shading1 = userCards[index1].shading
        let shading2 = userCards[index2].shading
        let shading3 = userCards[index3].shading
        
        let color1 = userCards[index1].color
        let color2 = userCards[index2].color
        let color3 = userCards[index3].color
        
        // numbers
        if !((number1 == number2 && number1 == number3) || (number1 != number2 && number1 != number3 && number2 != number3)){
            mismatched()
            return
        }
        
        // symbols
        if !((symbol1 == symbol2 && symbol1 == symbol3) || (symbol1 != symbol2 && symbol1 != symbol3 && symbol2 != symbol3)){
            mismatched()
            return
        }
        
        // shadings
        if !((shading1 == shading2 && shading1 == shading3) || (shading1 != shading2 && shading1 != shading3 && shading2 != shading3)){
            mismatched()
            return
        }
        
        // colors
        if !((color1 == color2 && color1 == color3) || (color1 != color2 && color1 != color3 && color2 != color3)){
            mismatched()
            return
        }
        
        matched(card1: userCards[index1], card2: userCards[index2], card3: userCards[index3])
    }
    
}

@objc protocol gameDelegate{
    func gameWon()
    func gameLost()
    func matched()
    func mismatched()
}
