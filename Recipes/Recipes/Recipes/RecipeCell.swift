//
//  RecipeCell.swift
//  Recipes
//
//  Created by Davit on 2/14/15.
//  Copyright (c) 2015 Davit. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class RecipeCell: UITableViewCell {
    @IBOutlet var lblDescription: UILabel?
    //@IBOutlet var txtPreparation: UITextView?
    @IBOutlet var theImage: UIImageView?
    weak var supView: MyViewController?
    var coords: CLLocationCoordinate2D? = nil
    
    @IBOutlet weak var locButton: UIButton!
    
    @IBAction func showLocation(sender: AnyObject) {
        println("Sender tag = \(sender.tag)")
        supView?.performSegueWithIdentifier("location", sender: self)
        
    }
    
    override func willMoveToSuperview(newSuperview: UIView?) {
        theImage?.layer.masksToBounds = true
        theImage?.layer.cornerRadius = 10
        locButton.layer.masksToBounds = true
        locButton.layer.cornerRadius = 2
    }

}