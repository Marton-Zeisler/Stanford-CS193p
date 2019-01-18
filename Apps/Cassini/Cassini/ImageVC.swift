//
//  ImageVC.swift
//  Cassini
//
//  Created by Marton Zeisler on 2018. 12. 01..
//  Copyright © 2018. marton. All rights reserved.
//

import UIKit

class ImageVC: UIViewController, UIScrollViewDelegate {
    
    
    var imageURL: URL?{
        didSet{
            image = nil
            // check if mvc is on screen
            // if view is on screen, it has a window
            if view.window != nil{
                fetchImage()
            }
            
        }
    }
    
    private var image: UIImage?{
        get{
            return imageView.image
        }set{
            imageView.image = newValue
            imageView.sizeToFit()
            scrollView?.contentSize = imageView.frame.size
            indicatorView?.stopAnimating()
        }
    }
    
    @IBOutlet weak var scrollView: UIScrollView!{
        didSet{
            scrollView.minimumZoomScale = 1/25
            scrollView.maximumZoomScale = 1.0
            scrollView.delegate = self
            scrollView.addSubview(imageView)
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    var imageView = UIImageView()
    
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        if imageURL == nil{
        //            imageURL = DemoURLs.stanford
        //        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if imageView.image == nil{
            fetchImage()
        }
    }
    
    //    private func fetchImage(){
    //        if let url = imageURL{
    //            indicatorView.startAnimating()
    //            DispatchQueue.global(qos: .userInitiated).async { [ weak self] in
    //                let urlContents = try? Data(contentsOf: url)
    //                DispatchQueue.main.async {
    //                    if let imageData = urlContents, url == self?.imageURL{
    //                        self?.image = UIImage(data: imageData)
    //                    }
    //                }
    //            }
    //        }
    //    }
    
    private func fetchImage(){
        if let url = imageURL{
            indicatorView.startAnimating()
            DispatchQueue.global(qos: .userInitiated).async {
                let urlContents = try? Data(contentsOf: url)
                if let imageData = urlContents, url == self.imageURL{
                    DispatchQueue.main.async {
                        self.image = UIImage(data: imageData)
                    }
                    
                }
            }
            
        }
    }
    
    
}
