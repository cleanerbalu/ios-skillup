//
//  ViewController.swift
//  Learn
//
//  Created by Davit on 1.22.15.
//  Copyright (c) 2015 Davit. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var newWordField: UITextField?
    @IBOutlet var viewTextField: UITextField?
    
    @IBAction func onTouchDown(sender: AnyObject) {
        let alrt = UIAlertController(title: "Tiitle", message: "Message", preferredStyle: UIAlertControllerStyle.Alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) {action -> Void in}
        
        let okAction = UIAlertAction(title: "Ok", style: .Default){
            action -> Void in
            (sender as UITextField).backgroundColor=UIColor.blueColor()
             self.viewTextField?.text =  self.newWordField?.text
        }
        
        alrt.addTextFieldWithConfigurationHandler {textField -> Void in
            textField.backgroundColor = UIColor.redColor()
            self.newWordField = textField
        }
        
        alrt.addAction(cancelAction)
        alrt.addAction(okAction)
                
        alrt.popoverPresentationController?.sourceView = sender as UIView
        
        self.presentViewController(alrt, animated: true , completion:{
        })
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

