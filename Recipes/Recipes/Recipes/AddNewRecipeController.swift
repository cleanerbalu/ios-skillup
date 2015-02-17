//
//  AddNewRecipeController.swift
//  Recipes
//
//  Created by Davit on 2.17.15.
//  Copyright (c) 2015 Davit. All rights reserved.
//

import Foundation
import UIKit

class AddNewRecipeController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet var lblDescription: UILabel?
    @IBOutlet var txtPreparation: UITextView?
    @IBOutlet var theImage: UIImageView?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        theImage?.backgroundColor = UIColor.greenColor()
        println ("AddNewRecipeController didload")
    
    }
    
    
    @IBAction func getPicture(sender: AnyObject) {
        takePicture()
    }

    
    func takePicture() {
        if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)) {
            let impick = UIImagePickerController()
            impick.sourceType = UIImagePickerControllerSourceType.Camera
            impick.delegate = self
            self.presentViewController(impick, animated: true, completion: nil)
        } else {
            let alrt = UIAlertView(title: "Error", message: "No Camera", delegate: nil, cancelButtonTitle: "კაი რას იზავ!")
            alrt.show()
        }
    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        theImage?.image = image
        //NSFileManager.defaultManager().createFileAtPath(<#path: String#>, contents: <#NSData?#>, attributes: <#[NSObject : AnyObject]?#>) image.
    }
    
    
}