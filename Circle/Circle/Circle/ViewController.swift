//
//  ViewController.swift
//  Circle
//
//  Created by User-3 on 2/9/15.
//  Copyright (c) 2015 User-3. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        

        let circle = UIView(frame: CGRect(x: 10,y: 10,width: 100,height: 100))
        circle.backgroundColor = UIColor.greenColor()
        circle.layer.cornerRadius = circle.frame.width / 4
        self.view.addSubview(circle)
        
        
        let path = UIBezierPath()
        path.moveToPoint(CGPoint(x: 16,y: 239))
        path.addCurveToPoint(CGPoint(x: 301, y: 239), controlPoint1: CGPoint(x: 136, y: 373), controlPoint2: CGPoint(x: 178, y: 110))
        
        path.addCurveToPoint(CGPoint(x: 16,y: 239), controlPoint1: CGPoint(x: 178, y: 10), controlPoint2: CGPoint(x: 136, y: 473))
        
        // create a new CAKeyframeAnimation that animates the objects position
        let anim = CAKeyframeAnimation(keyPath: "position")
        
        // set the animations path to our bezier curve
        anim.path = path.CGPath
        
        // set some more parameters for the animation
        // this rotation mode means that our object will rotate so that it's parallel to whatever point it is currently on the curve
        anim.rotationMode =  kCAAnimationRotateAuto//kCAAnimationRotateAutoReverse//kCAAnimationPaced//
        //anim.rotationMode =  kCAAnimationPaced//kCAAnimationRotateAuto
        anim.repeatCount = Float.infinity
        anim.duration = 4.0
        
        let anim2 = CAKeyframeAnimation(keyPath: "backgroundColor")
        anim2.values = [UIColor.redColor().CGColor,UIColor.blueColor().CGColor,UIColor.greenColor().CGColor,UIColor.redColor().CGColor]
        anim2.duration = 8.0
        anim2.repeatCount = Float.infinity
        
        let anim3 = CAKeyframeAnimation(keyPath: "cornerRadius")
        anim3.values = [0,50,0]
        anim3.duration = 14.0
        anim3.repeatCount = Float.infinity
        
        //anim2.
        //anim2.
        
        // we add the animation to the squares 'layer' property
        circle.layer.addAnimation(anim, forKey: "animate position along path")
        circle.layer.addAnimation(anim2, forKey: "color")
        circle.layer.addAnimation(anim3, forKey: "corner")

        
        //let path = CAKeyframeAnimation(
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

