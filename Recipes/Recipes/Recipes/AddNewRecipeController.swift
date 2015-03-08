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
    var annot: MKPointAnnotation? = nil
    var buttonCompass: UIBarButtonItem? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        theImage?.backgroundColor = UIColor.lightGrayColor()
        txtPreparation?.layer.cornerRadius = 10
        
        let tapGesture = UITapGestureRecognizer(target: self, action: "tapListener:")
        tapGesture.numberOfTapsRequired = 1
            self.theImage?.addGestureRecognizer(tapGesture)
        self.theImage?.userInteractionEnabled = true
        
        
        let tapPreparation = UITapGestureRecognizer(target: self,action: "inputPreparation:")
        txtPreparation?.addGestureRecognizer(tapPreparation)
        
        //location detection
        if CLLocationManager.locationServicesEnabled() {
            locManager = CLLocationManager()
            if let locMan = locManager {
                locMan.delegate = self
                locMan.desiredAccuracy = kCLLocationAccuracyBest
                if locMan.respondsToSelector("requestWhenInUseAuthorization") {
                    locMan.requestWhenInUseAuthorization()
                }
                locMan.startUpdatingLocation()
                locMan.startUpdatingHeading()
                
            }
        }
        lblDescription?.delegate = self
        fillFormFromManangedObject(recipeManagedObject)
        
        buttonCompass = UIBarButtonItem(title: "♂", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        buttonCompass!.enabled = false
  
        navigationItem.rightBarButtonItems?.append(buttonCompass!)

    }
    override func viewWillDisappear(animated: Bool) {
        locManager?.stopUpdatingLocation()
        locManager?.stopUpdatingHeading()
        timer?.invalidate()
    }
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.toolbarHidden = false
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
     func turnOnLocation (){
        if let locMan = locManager {
            locMan.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        currentCoord = (locations[locations.count-1] as CLLocation).coordinate
 
        if mapUserLoc.superview != nil {
            mapUserLoc.setRegion(MKCoordinateRegionMakeWithDistance(currentCoord!, 1000, 1000), animated: true)
            if annot == nil {
                annot = MKPointAnnotation()
            }
            annot!.setCoordinate(currentCoord!)
            annot!.title = NSLocalizedString("Here you are",  comment: "Annotation explanation")
            mapUserLoc.addAnnotation(annot!)
        }
        if locationDetected.superview != nil {
            UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: CGFloat(0.3), initialSpringVelocity: CGFloat(3.0), options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                    self.locationDetected.hidden = false
                    self.locationDetected.transform = CGAffineTransformMakeScale(0.7, 0.7)
                },
                completion: { finished in
                     UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: CGFloat(0.3), initialSpringVelocity: CGFloat(3.0), options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                            self.locationDetected.transform = CGAffineTransformMakeScale(1, 1)
                     },completion: nil)
                }
            )
        }
       manager.stopUpdatingLocation()
       timer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: "turnOnLocation", userInfo: nil, repeats: false)
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateHeading newHeading: CLHeading!) {
        /* not tested code due to absence of device!!! */
        
        let oldRad:Int = Int(arc4random_uniform(360))
        let newRad = Int(arc4random_uniform(360))
        
        let theAnimation = CABasicAnimation(keyPath: "transform.rotation");
        theAnimation.fromValue = oldRad;
        theAnimation.toValue = newRad;
        theAnimation.duration = 0.5;
        
        
        let compsView = buttonCompass?.valueForKey("view") as UIView
        compsView.layer.anchorPoint = CGPoint(x: 0.5,y: 0.5)
        
        UIView.beginAnimations("rotate",context: nil)
        compsView.transform = CGAffineTransformMakeRotation(CGFloat(newRad));
        UIView.commitAnimations()
    }
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        NSLog(error.description)
    }
    
    
    
    func tapListener(gesture: UITapGestureRecognizer){
        if gesture.state == UIGestureRecognizerState.Ended {
            let pos = gesture.locationInView(theImage)
            if pos.y > theImage!.frame.height/2 {
           
                let alert = UIAlertController(title:NSLocalizedString("Image",  comment: "aler ttitle") , message: NSLocalizedString("Select source",  comment: "alert message") , preferredStyle: UIAlertControllerStyle.ActionSheet)
                alert.addAction(UIAlertAction(title: NSLocalizedString("Camera",  comment: "camera button") , style: UIAlertActionStyle.Destructive, handler: { (alert:UIAlertAction!) in self.takePicture(0) }))
                alert.addAction(UIAlertAction(title:  NSLocalizedString("Photo Libary",  comment: "library buitton") , style: UIAlertActionStyle.Destructive, handler: { (alert:UIAlertAction!) in self.takePicture(1) }))
                alert.addAction(UIAlertAction(title: NSLocalizedString("Draw myself",  comment: "draw buitton"), style: UIAlertActionStyle.Destructive, handler: { (alert:UIAlertAction!) in self.takePicture(2) }))
                alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel",  comment: "cancel buitton"), style: UIAlertActionStyle.Cancel, handler: { (alert:UIAlertAction!) in return }))
                self.presentViewController(alert, animated: true, completion: nil)
            } else {
                takePicture()
            }
       }
    }
    func inputPreparation(gesture: UITapGestureRecognizer) {
        performSegueWithIdentifier("notes", sender: nil)
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
    func takePicture(source: UIImagePickerControllerSourceType) {
        if (UIImagePickerController.isSourceTypeAvailable(source)) {
            let impick = UIImagePickerController()
            impick.sourceType = source
            impick.delegate = self
            self.presentViewController(impick, animated: true, completion: nil)
        } else {
            let alrt = UIAlertView(title:  NSLocalizedString("Error",  comment: "error"),
                                    message: NSLocalizedString("No Camera",  comment: "No Camera"), delegate: nil,
                                    cancelButtonTitle: NSLocalizedString("OK, no problem",  comment: "cancel buton"))
            alrt.show()
        }
    }
    func takePicture(sourceType: Int) {
        switch sourceType {
        case 0:
            takePicture(UIImagePickerControllerSourceType.Camera)
        case 1:
            takePicture(UIImagePickerControllerSourceType.PhotoLibrary)
        case 2:
            self.performSegueWithIdentifier("draw", sender: self)
        default:
            break
        }
    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
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
    

    
    
    
    /******************  Actions,Buttons **********************/
    
    @IBAction func getPicture(sender: UIBarButtonItem) {
        takePicture(sender.tag)
        
    }

    @IBAction func SaveData(sender: AnyObject) {
        var descr = ""
        var prep = ""
        if let data = lblDescription?.text { descr = data }
        if let data = txtPreparation?.text { prep = data }
        
        if descr.isEmpty {
            let alrt = UIAlertView(title: NSLocalizedString("Error",  comment: "error"),
                                message: NSLocalizedString("Please specify title",  comment: "no title msg"),
                                delegate: nil,
                                cancelButtonTitle: NSLocalizedString("OK",  comment: "ok"))
            alrt.show()
        } else if prep.isEmpty {
            let alrt = UIAlertView(title: NSLocalizedString("Error", comment: "error"),
                                message: NSLocalizedString("Please specify preparation",  comment: "no recipe msg"), delegate: nil,
                                cancelButtonTitle: NSLocalizedString("OK",  comment: "ok"))
            alrt.show()
        } else {
            recipeModel.insertNewOrEditObject(recipeManagedObject,recipe: ModelRecipes.recipeDataType(shortDescribtion: descr, preparation: prep , image: theImage?.image,coords: currentCoord ),imageChanged: imageChanged)
            lblDescription?.text = ""
            txtPreparation?.text = ""
            theImage?.image = nil
            self.navigationController?.popViewControllerAnimated(true)
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
    
}