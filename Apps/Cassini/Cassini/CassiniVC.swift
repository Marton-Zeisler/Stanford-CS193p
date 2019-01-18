//
//  CassiniVC.swift
//  Cassini
//
//  Created by Marton Zeisler on 2018. 12. 01..
//  Copyright © 2018. marton. All rights reserved.
//

import UIKit

class CassiniVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier{
            if let url = DemoURLs.NASA[identifier]{
                if let imageVC = segue.destination.contents as? ImageVC{
                    imageVC.imageURL = url
                    imageVC.title = (sender as? UIButton)?.currentTitle
                }
            }
        }
    }

}


extension UIViewController{
    var contents: UIViewController{
        if let navcon = self as? UINavigationController{
            return navcon.visibleViewController ?? self
        }else{
            return self
        }
    }
}
