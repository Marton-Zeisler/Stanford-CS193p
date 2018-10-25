//
//  ViewController.swift
//  Concentration
//
//  Created by Marton Zeisler on 2018. 10. 20..
//  Copyright © 2018. marton. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var flipCountLabel: UILabel!
    @IBOutlet var cardButtons: [UIButton]!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var newGameButton: UIButton!
    var cardColor = UIColor.orange
    
    lazy var game = Concentration(numberOfPairsOfCards: (cardButtons.count+1)/2) // It's not initialised immediately, only gets initialised when someone tries to use game. DidSet is not available for lazy variables
    
    var theme: String?
    
    var originalEmojis = ["Animals": ["🐶","🦊","🐸","🐱", "🦋", "🐙", "🐀", "🐈"], "Food": ["🍑", "🥓", "🥟", "🌶", "🥝", "🍲", "🍕", "🌮"], "Smileys": ["😂", "😣", "😄", "😎", "😪", "🤑", "🤕", "🤗"] ]
    var emojiChoices = [String: [String]]() // same as original but its items get removed
    
    var emoji = [Int: String]()
    
    override func viewDidLoad() {
        originalEmojis["Sports"] = ["🏀", "⚽️", "⚾️", "🎾", "🥅", "🎱", "⛸", "⛷"]
        emojiChoices = originalEmojis
    }
    
    @IBAction func touchCard(_ sender: UIButton) {
        game.flipCount += 1
        
        if let cardNumber = cardButtons.index(of: sender){
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        }else{
            print("Chosen card was not in cardButtons")
        }
    }
    
    func updateViewFromModel(){
        flipCountLabel.text = "Flips: \(game.flipCount)"
        scoreLabel.text = "Score: \(Double(round(game.score*10)/10))"
        
        for index in cardButtons.indices{
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp{
                button.setTitle(emoji(for: card), for: .normal)
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            }else{
                button.setTitle("", for: .normal)
                button.backgroundColor = card.isMatched ?  #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 0) : cardColor
            }
        }
    }
    
    
    func emoji(for card: Card) ->String{
        if theme == nil{
            let randomIndex = Int(arc4random_uniform(UInt32(emojiChoices.count)))
            theme = Array(emojiChoices.keys)[randomIndex]
        }
        
        if emoji[card.identifier] == nil && emojiChoices[theme!]!.count > 0{
            let randomIndex = Int(arc4random_uniform(UInt32(emojiChoices[theme!]!.count)))
            emoji[card.identifier] = emojiChoices[theme!]!.remove(at: randomIndex)
        }
        
        
        return emoji[card.identifier] ?? "?"
    }
    
    @IBAction func newGameTapped(_ sender: UIButton) {
        emoji.removeAll()
        game.flipCount = 0
        game.score = 0
        theme = nil
        emojiChoices = originalEmojis
        for index in cardButtons.indices{
            cardButtons[index].backgroundColor = cardColor
            cardButtons[index].setTitle("", for: .normal)
            game.cards[index].isFaceUp = false
            game.cards[index].isMatched = false
            game.indexOfOneAndOnlyFaceUpCard = nil
        }
    }
    
    @IBAction func changeThemeTapped(_ sender: UIButton) {
        if view.backgroundColor == UIColor.black{
            view.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
            newGameButton.setTitleColor(#colorLiteral(red: 0.3411764801, green: 1, blue: 0.1686274558, alpha: 1), for: .normal)
            scoreLabel.textColor = #colorLiteral(red: 0.3411764801, green: 1, blue: 0.1686274558, alpha: 1)
            sender.setTitleColor(#colorLiteral(red: 0.3411764801, green: 1, blue: 0.1686274558, alpha: 1), for: .normal)
            flipCountLabel.textColor = #colorLiteral(red: 0.3411764801, green: 1, blue: 0.1686274558, alpha: 1)
            cardColor = #colorLiteral(red: 0.3411764801, green: 1, blue: 0.1686274558, alpha: 1)
            updateCardColors(color: #colorLiteral(red: 0.3411764801, green: 1, blue: 0.1686274558, alpha: 1))
        }else{
            view.backgroundColor = UIColor.black
            newGameButton.setTitleColor(UIColor.orange, for: .normal)
            scoreLabel.textColor = UIColor.orange
            sender.setTitleColor(UIColor.orange, for: .normal)
            flipCountLabel.textColor = UIColor.orange
            cardColor = UIColor.orange
            updateCardColors(color: UIColor.orange)
        }
    }
    
    func updateCardColors(color: UIColor){
        for each in cardButtons.indices{
            if !game.cards[each].isMatched && !game.cards[each].isFaceUp{
                cardButtons[each].backgroundColor = color
            }
        }
    }
    
}

