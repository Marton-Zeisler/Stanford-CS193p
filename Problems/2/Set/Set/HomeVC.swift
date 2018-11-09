//
//  ViewController.swift
//  Set
//
//  Created by Marton Zeisler on 2018. 10. 31..
//  Copyright © 2018. marton. All rights reserved.
//

import UIKit

class HomeVC: UIViewController{
    
    @IBOutlet var cardButtons: [UIButton]!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var dealMoreButton: UIButton!
    
    var total81Cards: [Card]!
    
    let game = Game()
    
    let colors = [#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1), #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)]
    let symbols: [Character] = ["▲", "●", "■"]
    
    var selectedIndexes = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        game.gameDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startNew()
    }
    
    func startNew(){
        game.startNew()
        updateUI()
    }
    
    func updateUI(){
        scoreLabel.text = "\(game.score ?? 0) pts"
        loadCards()
    }
    
    func loadCards(){
        if game.userCards.count < 24 {
            dealMoreButton.alpha = 1.0
            dealMoreButton.isEnabled = true
        }
        for each in game.userCards.indices{
            let colorOption = game.userCards[each].color
            let symbolOption = game.userCards[each].symbol
            let shadingOption = game.userCards[each].shading
            let numberOption = game.userCards[each].number
            
            // Setting the color
            cardButtons[each].setTitleColor(colors[colorOption], for: .normal)
            
            // Setting the symbol sequence
            let symbol = symbols[symbolOption]
            let symbolSequence = Array(repeating: symbol, count: numberOption+1)
            let title = String(symbolSequence)
            
            var attributes = [NSAttributedString.Key : Any]()
            // Setting the shading
            if shadingOption == 0{ // solid
                attributes = [.strokeWidth: 0.0, .foregroundColor: colors[colorOption].withAlphaComponent(1.0)]
            }else if shadingOption == 1{ // striped
                attributes = [.strokeWidth: 0.0, .foregroundColor: colors[colorOption].withAlphaComponent(0.3)]
            }else{ // open
                attributes = [.strokeWidth: 3.0, .foregroundColor: colors[colorOption].withAlphaComponent(1.0), .strokeColor: colors[colorOption]]
            }
            
            cardButtons[each].setAttributedTitle(NSAttributedString(string: title, attributes: attributes), for: .normal)
            cardButtons[each].alpha = 1.0
        }
        
        if game.userCards.count < 24{
            for each in game.userCards.count..<cardButtons.count{
                cardButtons[each].alpha = 0.0
            }
        }
        
    }
    
    
    @IBAction func cardTapped(_ sender: UIButton){
        //printCardDetails(sender)
        let selectedIndex = cardButtons.index(of: sender)!
        
        if selectedIndexes.count < 2 || selectedIndexes.contains(selectedIndex){ // just select/deselect it, nothing elese
            if sender.backgroundColor == UIColor.white{
                selectedIndexes.append(selectedIndex)
                sender.backgroundColor = #colorLiteral(red: 0.9254901961, green: 0.9254901961, blue: 0.9254901961, alpha: 1)
            }else{
                selectedIndexes.remove(at: selectedIndexes.index(of: selectedIndex)!)
                sender.backgroundColor = UIColor.white
            }
        }else if selectedIndexes.count == 2{ // check if the 3 selected ones match, then deselect all of them
            game.attemptMatch(index1: selectedIndex, index2: selectedIndexes[0], index3: selectedIndexes[1])
            
            cardButtons[selectedIndexes[0]].backgroundColor = UIColor.white
            cardButtons[selectedIndexes[1]].backgroundColor = UIColor.white
            selectedIndexes.removeAll()
        }
        
        
        
    }
    
    func printCardDetails(_ sender: UIButton){
        let index = cardButtons.index(of: sender)!
        let card = game.userCards[index]
        print("color: \(card.color)")
        print("number: \(card.number)")
        print("symbol: \(card.symbol)")
        print("shade: \(card.shading)")
    }
    
    @IBAction func dealMoreTapped(_ sender: UIButton){
        game.load3More()
        loadCards()
        if game.userCards.count == 24 {
            sender.alpha = 0.6
            sender.isEnabled = false
        }
    }
    
    @IBAction func startNewTapped(_ sender: UIButton){
        startNew()
    }

}


extension HomeVC: gameDelegate{
    func gameWon() {
        performSegue(withIdentifier: "result", sender: "won")
    }
    
    func gameLost() {
        performSegue(withIdentifier: "result", sender: "lost")
    }
    
    func matched() {
        statusLabel.text = "Match!"
        updateUI()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.statusLabel.text = "Select a card!"
        }
    }
    
    func mismatched() {
        statusLabel.text = "Mismatch!"
        self.scoreLabel.text = "\(game.score ?? 0) pts"
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.statusLabel.text = "Select a card!"
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "result"{
            let destination = segue.destination as! ResultVC
            if let sender = sender as? String{
                destination.won = sender == "won"
            }
        }
    }
}

