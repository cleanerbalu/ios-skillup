//
//  DetailsViewController.swift
//  Demo
//
//  Created by Oleh Sannikov on 26.01.15.
//  Copyright (c) 2015 Oleh Sannikov. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView?
    var image: UIImage?
    
    var swipeRecogLeft : UISwipeGestureRecognizer?
    var swipeRecogRight: UISwipeGestureRecognizer?
    
    var currentImageIndex: Int = 0
    var imageContainer = ImageContainer()
    
    
    override func viewDidLoad() {
        
        swipeRecogLeft = UISwipeGestureRecognizer(target: self, action: "swipedView:")
        swipeRecogLeft?.direction =  UISwipeGestureRecognizerDirection.Left
        self.view.addGestureRecognizer(swipeRecogLeft!)
        
        swipeRecogRight = UISwipeGestureRecognizer(target: self, action: "swipedView:")
        swipeRecogRight?.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(swipeRecogRight!)
        
        self.view.userInteractionEnabled = true
        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //imageView?.image = image
        imageView?.image = imageContainer[currentImageIndex]
    }
    
    func swipedView(sender: UISwipeGestureRecognizer){
        switch sender.direction {
        case UISwipeGestureRecognizerDirection.Right:
             changeImageBy(1)
        case UISwipeGestureRecognizerDirection.Left:
            changeImageBy(-1)
        default:
            break
        }
    }
    
    func changeImageBy(theChange: Int){
        currentImageIndex += theChange
        switch currentImageIndex {
        case let i where i<0:
            currentImageIndex = imageContainer.count - 1
        case let i where i >= imageContainer.count:
            currentImageIndex = 0
        default:
            break
        }
        imageView?.image = imageContainer[currentImageIndex]
    }
}
