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
    @IBOutlet var lblDescription: UITextField?
    @IBOutlet var txtPreparation: UITextView?
    @IBOutlet var theImage: UIImageView?

    var recipeModel = ModelRecipes()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        theImage?.backgroundColor = UIColor.lightGrayColor()
        println ("AddNewRecipeController didload")
    
    }
    
    @IBAction func SaveData(sender: AnyObject) {
        var descr = ""
        var prep = ""
        if let data = lblDescription?.text { descr = data }
        if let data = txtPreparation?.text { prep = data }
        println("Descf \(descr)")
        println("Prep \(prep)")
        
        if descr.isEmpty {
            let alrt = UIAlertView(title: "Error", message: "Please specify short description", delegate: nil, cancelButtonTitle: "Ok")
            alrt.show()
        } else if prep.isEmpty {
            let alrt = UIAlertView(title: "Error", message: "Please specify preparation", delegate: nil, cancelButtonTitle: "Ok")
            alrt.show()
        } else {
            var imageData = UIImagePNGRepresentation(theImage?.image)
            let fileManager = NSFileManager.defaultManager()
            let uuid = NSUUID().UUIDString
            let fileName = "recipe\(uuid).png"
            let filePathToWrite = "\(glPicturePath)/\(fileName)"
            fileManager.createFileAtPath(filePathToWrite, contents: imageData, attributes: nil)
            println(filePathToWrite)
            
            recipeModel.insertNewObject(ModelRecipes.recipeDataType(shortDescribtion: descr, preparation: prep , imageLocation: fileName))
            lblDescription?.text = ""
            txtPreparation?.text = ""
            theImage?.image = nil
        }
    
        
    }
    
    @IBAction func getPicture(sender: AnyObject) {
        takePicture()
    }

    
    func takePicture() {
        if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary)) {
            let impick = UIImagePickerController()
            impick.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            impick.delegate = self
            self.presentViewController(impick, animated: true, completion: nil)
        } else {
            let alrt = UIAlertView(title: "Error", message: "No Camera", delegate: nil, cancelButtonTitle: "კაი რას იზავ!")
            alrt.show()
        }
    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        println("didFinishPickingImage")
        theImage?.image = image
        
        //NSFileManager.defaultManager().createFileAtPath(<#path: String#>, contents: <#NSData?#>, attributes: <#[NSObject : AnyObject]?#>) image.
    }
    
    
}