//
//  SignUpViewController.swift
//  CloudNotes
//
//  Created by Oleh Sannikov on 02.02.15.
//  Copyright (c) 2015 Oleh Sannikov. All rights reserved.
//

import UIKit
import Parse

class SignUpViewController: UIViewController {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var email: UITextField!

    @IBAction func signUp(sender: AnyObject?) {
        let name = username.text
        let pass = password.text
        let emailAddress = email.text
        
        let user = PFUser()
        user.username = name
        user.password = pass
        user.email = emailAddress
        
        user.signUpInBackgroundWithBlock { (result, error) -> Void in
            if error == nil {
                self.navigationController?.popToRootViewControllerAnimated(true)
            }
        }
    }
}
