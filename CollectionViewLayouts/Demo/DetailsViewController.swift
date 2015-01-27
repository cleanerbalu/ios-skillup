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
    var swipeRecog: UISwipeGestureRecognizer?

    override func viewDidLoad() {
        swipeRecog = UISwipeGestureRecognizer(target: self, action: "swipedView")
        swipeRecog?.direction = UISwipeGestureRecognizerDirection.Right | UISwipeGestureRecognizerDirection.Left
        self.view.addGestureRecognizer(swipeRecog!)
        self.view.userInteractionEnabled = true
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        imageView?.image = image
    }
    
    func swipedView(){
        let tapAlert = UIAlertController(title: "Swiped", message: "You just swiped the swipe view", preferredStyle: UIAlertControllerStyle.Alert)
        tapAlert.addAction(UIAlertAction(title: "OK", style: .Destructive, handler: nil))
        self.presentViewController(tapAlert, animated: true, completion: nil)
    }
    
    func swipeAction(){
        println("swiped")
    }
}
