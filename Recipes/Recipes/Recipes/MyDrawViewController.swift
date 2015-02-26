//
//  MyDrawViewController.swift
//  Recipes
//
//  Created by Davit on 2.26.15.
//  Copyright (c) 2015 Davit. All rights reserved.
//


class MyDrawViewController: UIViewController,NEOColorPickerViewControllerDelegate {

    override func viewWillAppear(animated: Bool) {
        self.navigationController?.toolbarHidden = false
    }
    
    @IBAction func colorsPicker(sender: AnyObject) {
        let color = NEOColorPickerViewController()
        color.delegate = self
        color.selectedColor = self.view.backgroundColor
        color.title = "Choose color"
        self.navigationController?.toolbarHidden = true
        self.navigationController?.pushViewController(color, animated: true)
    }

    func colorPickerViewController(controller: NEOColorPickerBaseViewController!, didSelectColor color: UIColor!) {
        (self.view as MyDrawView).setCurrentColor(color)
         controller.navigationController?.popViewControllerAnimated(true)
    }
 
    func colorPickerViewControllerDidCancel(controller: NEOColorPickerBaseViewController!) {
        controller.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func unwind(sender: UIStoryboardSegue) {
        println("unwind")
        
    }
    
    override func canPerformUnwindSegueAction(action: Selector, fromViewController: UIViewController, withSender sender: AnyObject) -> Bool {
        println("unwind canperform")
        return true
    }
    
    override func removeFromParentViewController() {
        println(" removeFromParentViewController")
    }
    
    override func willMoveToParentViewController(parent: UIViewController?) {
        println("willMoveToParentViewController")
    }

}
