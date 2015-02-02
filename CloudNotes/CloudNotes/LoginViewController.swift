//
//  LoginViewController.swift
//  CloudNotes
//
//  Created by Oleh Sannikov on 02.02.15.
//  Copyright (c) 2015 Oleh Sannikov. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!

    @IBAction func loginAction(sender: AnyObject) {
        
        let name = username.text
        let pass = password.text
        
        PFUser.logInWithUsernameInBackground(name, password: pass) { (user, error) -> Void in
            if error == nil {
                self.navigationController?.popViewControllerAnimated(true)
            } else {
                let alr = UIAlertView(title: "Error",
                    message: error.description,
                    delegate: self,
                    cancelButtonTitle: "Cancel")
                alr.show()
            }
        }
    }
}
