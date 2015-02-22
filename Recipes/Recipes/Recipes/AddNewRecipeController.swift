//
//  AddNewRecipeController.swift
//  Recipes
//
//  Created by Davit on 2.17.15.
//  Copyright (c) 2015 Davit. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class AddNewRecipeController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,CLLocationManagerDelegate {
    @IBOutlet var lblDescription: UITextField?
    @IBOutlet var txtPreparation: UITextView?
    @IBOutlet var theImage: UIImageView?

    var recipeModel = ModelRecipes()
    var locManager: CLLocationManager?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        theImage?.backgroundColor = UIColor.lightGrayColor()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: "tapListener:")
        tapGesture.numberOfTapsRequired = 1
        //tapGesture.nu
        self.theImage?.addGestureRecognizer(tapGesture)
        self.theImage?.userInteractionEnabled = true
        
        locManager = CLLocationManager()
        locManager?.startUpdatingLocation()
    }
    
    
    
    func tapListener(gesture: UITapGestureRecognizer){
        //if gesture.state == UIGestureRecognizerState.Ended {
            takePicture()
        //}
        
    }
    @IBAction func SaveData(sender: AnyObject) {
        var descr = ""
        var prep = ""
        if let data = lblDescription?.text { descr = data }
        if let data = txtPreparation?.text { prep = data }
        
        if descr.isEmpty {
            let alrt = UIAlertView(title: "Error", message: "Please specify short description", delegate: nil, cancelButtonTitle: "Ok")
            alrt.show()
        } else if prep.isEmpty {
            let alrt = UIAlertView(title: "Error", message: "Please specify preparation", delegate: nil, cancelButtonTitle: "Ok")
            alrt.show()
        } else {
            recipeModel.insertNewObject(ModelRecipes.recipeDataType(shortDescribtion: descr, preparation: prep , imageLocation: nil, image: theImage?.image))
            lblDescription?.text = ""
            txtPreparation?.text = ""
            theImage?.image = nil
            self.navigationController?.popViewControllerAnimated(true)
        }
    
        
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
        println("didFinishPickingImage")
        theImage?.image = image
        picker.dismissViewControllerAnimated(true, completion: nil)
        //NSFileManager.defaultManager().createFileAtPath(<#path: String#>, contents: <#NSData?#>, attributes: <#[NSObject : AnyObject]?#>) image.
    }
    
    
    
}