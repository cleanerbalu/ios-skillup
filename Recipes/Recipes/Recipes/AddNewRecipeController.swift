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
    
    var currentCoord: CLLocationCoordinate2D? = nil
    override func viewDidLoad() {
        
        super.viewDidLoad()
        theImage?.backgroundColor = UIColor.lightGrayColor()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: "tapListener:")
        tapGesture.numberOfTapsRequired = 1
        //tapGesture.nu
        self.theImage?.addGestureRecognizer(tapGesture)
        self.theImage?.userInteractionEnabled = true
        
        
        //location detection
        if CLLocationManager.locationServicesEnabled() {
            println("locserv enabled")
            locManager = CLLocationManager()
            
            if let locMan = locManager {
                println("locManager is here")
                locMan.delegate = self
                
                locMan.desiredAccuracy = kCLLocationAccuracyBest
                if locMan.respondsToSelector("requestWhenInUseAuthorization") {
                    
                    locMan.requestWhenInUseAuthorization()
                    println("realy did requestWhenInUseAuthorization")
                } else {
                    println("no respond on requestWhenInUseAuthorization")
                }
                
                locMan.startUpdatingLocation()
                locMan.startUpdatingHeading()
            } else {
                println("No locManager")
            }
        } else {
            println("locserv disabled")
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        println("locationManager coord saved")
        currentCoord = (locations[locations.count-1] as CLLocation).coordinate
        
    }
    func locationManager(manager: CLLocationManager!, didUpdateHeading newHeading: CLHeading!) {
        println("got heading update")
    }
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println(error)
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
            recipeModel.insertNewObject(ModelRecipes.recipeDataType(shortDescribtion: descr, preparation: prep , image: theImage?.image,coords: currentCoord ))
            lblDescription?.text = ""
            txtPreparation?.text = ""
            theImage?.image = nil
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    @IBAction func getPicture(sender: AnyObject) {
        takePicture()
    }

    override func viewWillDisappear(animated: Bool) {
        println("AddNewReciprContr will disapear")
        locManager?.stopUpdatingLocation()
        locManager?.stopUpdatingHeading()
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