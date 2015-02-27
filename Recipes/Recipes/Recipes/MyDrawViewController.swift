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
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.toolbarHidden = false
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
