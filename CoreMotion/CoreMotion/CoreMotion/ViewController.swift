//
//  ViewController.swift
//  CoreMotion
//
//  Created by User-3 on 2/16/15.
//  Copyright (c) 2015 User-3. All rights reserved.
//

import UIKit
import CoreMotion
class ViewController: UIViewController {
    let cmmgr = CMMotionManager()
    var myview: UIView? =  nil
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        myview =  UIView(frame: CGRect(x: 10,y: 10,width: 100,height: 100))
        myview?.backgroundColor = UIColor.redColor()
        self.view.addSubview(myview!)
        motionReader()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func motionReader() {
        if cmmgr.deviceMotionAvailable {
            cmmgr.deviceMotionUpdateInterval = 0.1
            cmmgr.startDeviceMotionUpdatesToQueue(NSOperationQueue.currentQueue() ,
                withHandler: {
                    (motion: CMDeviceMotion!, error: NSError!) in
                     println(motion.gravity.x)
                    myview?.transform = CFARot
                    
                    
                })
            
        }
       
    }

}

