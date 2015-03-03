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
import MapKit
import CoreData
import AVFoundation
import Photos

class AddNewRecipeController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,CLLocationManagerDelegate, UITextFieldDelegate {
    @IBOutlet weak var lblDescription: UITextField?
    @IBOutlet weak var txtPreparation: UITextView?
    @IBOutlet weak var theImage: UIImageView?
    @IBOutlet weak var mapUserLoc: MKMapView!
    @IBOutlet weak var locationDetected: UIImageView!
    
    var timer: NSTimer? = nil
    var recipeModel = ModelRecipes()
    var locManager: CLLocationManager?
    var recipeManagedObject: NSManagedObject? = nil
    var currentCoord: CLLocationCoordinate2D? = nil
    var imageChanged: Bool = false
    override func viewDidLoad() {
        
        super.viewDidLoad()
        theImage?.backgroundColor = UIColor.lightGrayColor()
        txtPreparation?.layer.cornerRadius = 20
        let tapGesture = UITapGestureRecognizer(target: self, action: "tapListener:")
        tapGesture.numberOfTapsRequired = 1
        //tapGesture.nu
        self.theImage?.addGestureRecognizer(tapGesture)
        self.theImage?.userInteractionEnabled = true
        
        
        let tapPreparation = UITapGestureRecognizer(target: self,action: "inputPreparation:")
        txtPreparation?.addGestureRecognizer(tapPreparation)
        
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
                //locMan.startUpdatingHeading()
            } else {
                println("No locManager")
            }
        } else {
            println("locserv disabled")
        }
        
        lblDescription?.delegate = self
        fillFormFromManangedObject(recipeManagedObject)

    }
    
    func fillFormFromManangedObject(dataObject: NSManagedObject?){
        if let object = dataObject {
            lblDescription!.text = object.valueForKey("shortDescr")!.description
            txtPreparation!.text = object.valueForKey("preparation")!.description
            
            if let obj: AnyObject = object.valueForKey("imageLocation") {
                if obj.description != nil {
                    theImage?.image = UIImage(contentsOfFile: "\(glPicturePath)/\(obj.description)")
                }
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.toolbarHidden = false
         //fillFormFromManangedObject(object)
    }
    
    
  
    
    func turnOnLocation (){
        if let locMan = locManager {
            locMan.startUpdatingLocation()
        }
        
    }
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        println("locationManager coord saved")
        currentCoord = (locations[locations.count-1] as CLLocation).coordinate
        
        if mapUserLoc.superview != nil {
            mapUserLoc.setRegion(MKCoordinateRegionMakeWithDistance(currentCoord!, 1000, 1000), animated: true)
            let annot = MKPointAnnotation()
            annot.setCoordinate(currentCoord!)
            annot.title = "Here did you the recipe"
            mapUserLoc.addAnnotation(annot)
            println("Annotation done")
        
        }
        
        if locationDetected.superview != nil {
            UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: CGFloat(0.3), initialSpringVelocity: CGFloat(3.0), options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                    self.locationDetected.hidden = false
                    //self.locationDetected.transform = CGAffineTransformMakeRotation(2*3.14)
                    self.locationDetected.transform = CGAffineTransformMakeScale(0.7, 0.7)//(2*3.14)
                },
                completion: { finished in
                     UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: CGFloat(0.3), initialSpringVelocity: CGFloat(3.0), options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                            self.locationDetected.transform = CGAffineTransformMakeScale(1, 1)
                     },completion: nil)
                }
            )
        }

       manager.stopUpdatingLocation()
       timer = NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: "turnOnLocation", userInfo: nil, repeats: false)
        
    }
    func locationManager(manager: CLLocationManager!, didUpdateHeading newHeading: CLHeading!) {
        println("got heading update")
    }
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println(error)
    }
    
    func tapListener(gesture: UITapGestureRecognizer){
        if gesture.state == UIGestureRecognizerState.Ended {
            takePicture()
        }
        
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
            recipeModel.insertNewOrEditObject(recipeManagedObject,recipe: ModelRecipes.recipeDataType(shortDescribtion: descr, preparation: prep , image: theImage?.image,coords: currentCoord ),imageChanged: imageChanged)
            lblDescription?.text = ""
            txtPreparation?.text = ""
            theImage?.image = nil
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    func isCameraAvaliable() -> Bool {
        var res =  false
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            let avstatus = AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeVideo)
            switch (avstatus) {
            case AVAuthorizationStatus.Authorized:
                res = true
            case AVAuthorizationStatus.NotDetermined:
                AVCaptureDevice.requestAccessForMediaType(AVMediaTypeVideo, completionHandler: {res = $0 })
            default:
                break
            }
        }
        return res
    }
    
    func isPhotoLibraryAvailabel() -> Bool {
        var res = false
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
            let authStatus = PHPhotoLibrary.authorizationStatus()
            switch authStatus {
            case PHAuthorizationStatus.Authorized:
                res = true
            case PHAuthorizationStatus.NotDetermined:
                PHPhotoLibrary.requestAuthorization({ res = ($0 == PHAuthorizationStatus.Authorized) })
            default:
                break
            }
        }
        return res
    }
    
    
    func takePicture(){
        if isCameraAvaliable() {
            takePicture(UIImagePickerControllerSourceType.Camera)
        } else if isPhotoLibraryAvailabel() {
            takePicture(UIImagePickerControllerSourceType.PhotoLibrary)
        } else {
            self.performSegueWithIdentifier("draw", sender: self)
        }
        
    }
    @IBAction func getPicture(sender: UIBarButtonItem) {
        switch sender.tag {
        case 0:
           takePicture(UIImagePickerControllerSourceType.Camera)
        case 1:
            takePicture(UIImagePickerControllerSourceType.PhotoLibrary)
            //PHPoto
            //UIImagePickerController.
            
        case 2:
            self.performSegueWithIdentifier("draw", sender: self)
          default:
            break
        }
        
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "draw" {
                let dst = segue.destinationViewController as MyDrawViewController
                dst.addRecipeViewController = self
        } else if segue.identifier == "notes" {
                let dst = segue.destinationViewController as MyNoteViewController
                dst.addRecipeController = self
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        println("AddNewReciprContr will disapear")
        locManager?.stopUpdatingLocation()
        locManager?.stopUpdatingHeading()
        timer?.invalidate()
    }
    
    func takePicture(source: UIImagePickerControllerSourceType) {
        if (UIImagePickerController.isSourceTypeAvailable(source)) {
            let impick = UIImagePickerController()
            impick.sourceType = source
            impick.delegate = self
            self.presentViewController(impick, animated: true, completion: nil)
        } else {
            let alrt = UIAlertView(title: "Error", message: "No Camera", delegate: nil, cancelButtonTitle: "კაი რას იზავ!")
            alrt.show()
        }
    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        println("didFinishPickingImage")
        takeDrawenImage(image)
        picker.dismissViewControllerAnimated(true, completion: nil)
     }
    
    func takeDrawenImage(img: UIImage){
        theImage?.image = img
        imageChanged = true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    func inputPreparation(gesture: UITapGestureRecognizer) {
        performSegueWithIdentifier("notes", sender: nil)
    }
    
}