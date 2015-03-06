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
    @IBOutlet var theImage: UIImageView?
    @IBOutlet weak var locButton: UIButton!
    
    weak var superListView: RListViewController?
    var coords: CLLocationCoordinate2D? = nil
    

    
    @IBAction func showLocation(sender: AnyObject) {
        println("Sender tag = \(sender.tag)")
        superListView?.performSegueWithIdentifier("location", sender: self)
        
    }
    
    override func willMoveToSuperview(newSuperview: UIView?) {
        theImage?.layer.masksToBounds = true
        theImage?.layer.cornerRadius = 10
        locButton.layer.masksToBounds = true
        locButton.layer.cornerRadius = 2
    }

}