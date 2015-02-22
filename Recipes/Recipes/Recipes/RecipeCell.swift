//
//  RecipeCell.swift
//  Recipes
//
//  Created by Davit on 2/14/15.
//  Copyright (c) 2015 Davit. All rights reserved.
//

import Foundation
import UIKit
class RecipeCell: UITableViewCell {
    @IBOutlet var lblDescription: UILabel?
    @IBOutlet var txtPreparation: UITextView?
    @IBOutlet var theImage: UIImageView?
    weak var supView: MyViewController?
    
    @IBOutlet weak var locButton: UIButton!
    
    @IBAction func showLocation(sender: AnyObject) {
        supView?.performSegueWithIdentifier("location", sender: sender)
    }
}