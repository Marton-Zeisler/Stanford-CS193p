//
//  ResultVC.swift
//  Set
//
//  Created by Marton Zeisler on 2018. 11. 09..
//  Copyright © 2018. marton. All rights reserved.
//

import UIKit

class ResultVC: UIViewController {

    @IBOutlet weak var resultLabel: UILabel!
    
    var won = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        resultLabel.text = won ? "YOU WON" : "YOU LOST"
        
    }
    
    @IBAction func restartTapped(_ sender: UIButton){
        dismiss(animated: true, completion: nil)
    }
    



}
