 //
//  ViewController.swift
//  Concentration
//
//  Created by Marton Zeisler on 2018. 10. 20..
//  Copyright © 2018. marton. All rights reserved.
//

import UIKit



class ViewController: UIViewController {
    
    private(set) var flipCount = 0 {
        didSet{
            updateFlipCountLabel()
        }
    }
    
    private func updateFlipCountLabel(){
        let attributes: [NSAttributedString.Key: Any] = [.strokeWidth: 5.0, .strokeColor: UIColor.orange]
        
        let attributesString = NSAttributedString(string: "Flips: \(flipCount)", attributes: attributes)
        flipCountLabel.attributedText = attributesString
    }
    
    var numberOfPairsOfCards: Int{
        return (cardButtons.count+1)/2
    }
    
    @IBOutlet private weak var flipCountLabel: UILabel!{
        didSet{
            updateFlipCountLabel()
        }
    }
    @IBOutlet private var cardButtons: [UIButton]!
    
    private lazy var game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards) // It's not initialised immediately, only gets initialised when someone tries to use game. DidSet is not available for lazy variables
    
    @IBAction private func touchCard(_ sender: UIButton) {
        flipCount += 1
    
        if let cardNumber = cardButtons.index(of: sender){
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        }else{
            print("Chosen card was not in cardButtons")
        }
    }
    
    private func updateViewFromModel(){
        for index in cardButtons.indices{
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp{
                button.setTitle(emoji(for: card), for: .normal)
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            }else{
                button.setTitle("", for: .normal)
                button.backgroundColor = card.isMatched ?  #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 0) : #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
            }
        }
    }
    
    private var emojiChoices = "🐶🦊🐸🐱🦋🐙🐀🐈🐠"
    
    private var emoji = [Card: String]()
    
    private func emoji(for card: Card) ->String{
        if emoji[card] == nil && emojiChoices.count > 0{
            let randomStringIndex = emojiChoices.index(emojiChoices.startIndex, offsetBy: emojiChoices.count.arc4random)
            emoji[card] = String(emojiChoices.remove(at: randomStringIndex))
        }
        
        return emoji[card] ?? "?"
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
