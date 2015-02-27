//
//  MyNoteViewController.swift
//  Recipes
//
//  Created by Davit on 2.27.15.
//  Copyright (c) 2015 Davit. All rights reserved.
//

import Foundation
import UIKit

class MyNoteViewController: UIViewController {

    @IBOutlet weak var theNote: UITextView!
    weak var addRecipeController: AddNewRecipeController?
    
    override func viewDidLoad() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWasShown:", name: UIKeyboardDidShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillBeHidden:", name: UIKeyboardWillHideNotification, object: nil)
        if addRecipeController?.txtPreparation?.text != nil {
            theNote.text = addRecipeController?.txtPreparation?.text
        }
        
        resetInsets()
       
    }
   
 
    override func viewWillAppear(animated: Bool) {
        navigationController?.toolbarHidden = true
        resetInsets()
    }
    
    func resetInsets(){
        let contentInsets = UIEdgeInsetsZero
        theNote.contentInset = contentInsets
        theNote.scrollIndicatorInsets = contentInsets
    }
    
    func keyboardWasShown(notification: NSNotification){
        let info = (notification.userInfo! as NSDictionary)
        let kbSize = info.objectForKey(UIKeyboardFrameBeginUserInfoKey)?.CGRectValue().size
        
        let contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize!.height, 0.0)
        theNote.contentInset = contentInsets
        theNote.scrollIndicatorInsets = contentInsets
    }
    
    func keyboardWillBeHidden(notification: NSNotification) {
        resetInsets()
    }
    
    @IBAction func saveNote(sender: AnyObject) {
        addRecipeController?.txtPreparation?.text = theNote.text
        navigationController?.popViewControllerAnimated(true)
    }
}