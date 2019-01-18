//
//  ConcentrationThemeChooserVC.swift
//  Concentration
//
//  Created by Marton Zeisler on 2018. 11. 27..
//  Copyright © 2018. marton. All rights reserved.
//

import UIKit

class ConcentrationThemeChooserVC: UIViewController, UISplitViewControllerDelegate {

    
    let themes = [
        "SPORTS": "⚽️🏀🏈⚾️🎾🏐🏉🎱🏓⛷🎳⛳️",
        "ANIMALS": "🐶🦆🐹🐸🐘🦍🐓🐩🐦🦋🐙🐏",
        "FACES": "😀😌😎🤓😠😤😭😰😱😳😜😇"
    ]
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        splitViewController?.delegate = self
    }
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        if let vc = secondaryViewController as? ConcentrationVC{
            if vc.theme == nil{
                return true
            }
        }
        
        return false
    }
    
    @IBAction func changeTheme(_ sender: Any) {
        if let vc = splitViewDetailVC{
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName]{
                vc.theme = theme
            }
        }else if let vc = lastSeguedConcentrationVC{
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName]{
                vc.theme = theme
            }
            navigationController?.pushViewController(vc, animated: true)
        }else{
            performSegue(withIdentifier: "Choose theme", sender: sender)
        }
    }
    
    private var splitViewDetailVC: ConcentrationVC?{
        return splitViewController?.viewControllers.last as? ConcentrationVC
    }
    
    private var lastSeguedConcentrationVC: ConcentrationVC?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Choose theme"{
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName]{
                if let vc = segue.destination as? ConcentrationVC{
                    vc.theme = theme
                    lastSeguedConcentrationVC = vc
                }
            }
        }
    }

 
}
