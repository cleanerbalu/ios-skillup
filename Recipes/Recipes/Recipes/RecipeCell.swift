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
import LocalAuthentication

class RecipeCell: UITableViewCell {
    @IBOutlet var lblDescription: UILabel?
    @IBOutlet var theImage: UIImageView?
    @IBOutlet weak var locButton: UIButton!
    
    weak var superListView: RListViewController?
    var coords: CLLocationCoordinate2D? = nil
    

    
    @IBAction func showLocation(sender: AnyObject) {
        /* not tested code due to absence of device!!! */
        
        
        //just troll User WithTouchID
        let cntx = LAContext()
        var err: NSError? = nil
        if cntx.canEvaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics,error: &err) {
            cntx.evaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, localizedReason: NSLocalizedString("To access inspiration location",  comment: "why authenticate"),
                reply: { (success:Bool, err: NSError!) -> Void in
                    if success {
                        UIAlertView(title:  NSLocalizedString("Authentication",  comment: "Authentication"),
                            message: NSLocalizedString("Passed",  comment: "touchId ok"), delegate: nil,
                            cancelButtonTitle: NSLocalizedString("Cancel",  comment: "cancel buitton")).show()
                        self.superListView?.performSegueWithIdentifier("location", sender: self)
                        
                    } else {
                        UIAlertView(title:  NSLocalizedString("Authentication",  comment: "Authentication"),
                            message: NSLocalizedString("Not passed...but I trust you",  comment: "touchId not ok"), delegate: nil,
                            cancelButtonTitle: NSLocalizedString("Cancel",  comment: "cancel buitton")).show()
                        self.superListView?.performSegueWithIdentifier("location", sender: self)
                    }
            })
        } else {
            UIAlertView(title:  NSLocalizedString("Authentication",  comment: "Authentication"),
                message: NSLocalizedString("Not TouchID...but I trust you",  comment: "touchId not ok"), delegate: nil,
                cancelButtonTitle: NSLocalizedString("Cancel",  comment: "cancel buitton")).show()
            self.superListView?.performSegueWithIdentifier("location", sender: self)
        }
    }
    
    override func willMoveToSuperview(newSuperview: UIView?) {
        theImage?.layer.masksToBounds = true
        theImage?.layer.cornerRadius = 10
        locButton.layer.masksToBounds = true
        locButton.layer.cornerRadius = 2
    }

}