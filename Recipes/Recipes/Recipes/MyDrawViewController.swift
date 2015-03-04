//
//  MyDrawViewController.swift
//  Recipes
//
//  Created by Davit on 2.26.15.
//  Copyright (c) 2015 Davit. All rights reserved.
//


class MyDrawViewController: UIViewController,NEOColorPickerViewControllerDelegate {
    var addRecipeViewController: AddNewRecipeController?
    
    @IBOutlet weak var linewidth: UIBarButtonItem!
    
    override func viewDidLoad() {
       /* let ui = UIStepper()
        ui.transform = CGAffineTransformMakeScale(0.8, 0.8)
        ui.autorepeat = true
        ui.maximumValue = 20
        ui.minimumValue = 1
        ui.stepValue = 2
        ui.addTarget(self, action: "stepperValue:", forControlEvents: UIControlEvents.ValueChanged)
        
        ui.addConstraint(NSLayoutConstraint(item: self., attribute: <#NSLayoutAttribute#>, relatedBy: <#NSLayoutRelation#>, toItem: <#AnyObject?#>, attribute: <#NSLayoutAttribute#>, multiplier: <#CGFloat#>, constant: <#CGFloat#>))
        let barbut = UIBarButtonItem(customView: ui)
        
        
        self.toolbarItems?.insert(barbut, atIndex: 0)
*/

    }
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.toolbarHidden = false
    }
    
    func stepperValue(stepper: UIStepper){
        (view as MyDrawView).setLineSize(Float(stepper.value))
        linewidth.title = String(Int((view as MyDrawView).getLine()))

    }
    @IBAction func undoLastLine(sender: AnyObject) {
        (self.view as MyDrawView).undoLine()
    }
    
    @IBAction func colorsPicker(sender: AnyObject) {
        let color = NEOColorPickerViewController()
        color.delegate = self
        color.selectedColor = (view as MyDrawView).getCurrentColor()
        color.title = "Choose color"
        self.navigationController?.toolbarHidden = true
        self.navigationController?.pushViewController(color, animated: true)
    }

    func colorPickerViewController(controller: NEOColorPickerBaseViewController!, didSelectColor color: UIColor!) {
        (view as MyDrawView).setCurrentColor(color)
         controller.navigationController?.popViewControllerAnimated(true)
    }
 
    func colorPickerViewControllerDidCancel(controller: NEOColorPickerBaseViewController!) {
        controller.navigationController?.popViewControllerAnimated(true)
    }
    

    
    @IBAction func savePicture(sender: AnyObject) {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0)
        view.layer.renderInContext(UIGraphicsGetCurrentContext())
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        addRecipeViewController?.takeDrawenImage(img)
        navigationController?.popViewControllerAnimated(true)
    }
    

    @IBAction func clearPicture(sender: AnyObject) {
        (view as MyDrawView).clear()
        
    }
   
    @IBAction func decLine(sender: AnyObject) {
        (view as MyDrawView).decreaseLine()
        linewidth.title = String((view as MyDrawView).getLine())
    }
    @IBAction func incLine(sender: AnyObject) {
        (view as MyDrawView).increaseLine()
        linewidth.title = String((view as MyDrawView).getLine())
    }
}
