//
//  MyTableView.swift
//  Recipes
//
//  Created by Davit on 2.23.15.
//  Copyright (c) 2015 Davit. All rights reserved.
//

import UIKit

class MyDrawView: UIView {
    var points: [CGPoint]
    var myPath = UIBezierPath()
    
    override init() {
        points = []
        myPath.lineWidth = 4.0
        super.init()
    }
    
    required init(coder aDecoder: NSCoder) {
        points = []
        myPath.lineWidth = 4.0
        
        super.init(coder: aDecoder)
    }
    override func drawRect(rect: CGRect) {
        UIColor.redColor().setStroke()
        /*
        if points.count > 1 {
            myPath.moveToPoint(points[0])
            for idx in 1...(points.count-1) {
                myPath.addLineToPoint(points[idx])
            }
            
            myPath.stroke()
        }*/
        myPath.stroke()
        println("drawRect \(rect)")
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        let touch = touches.anyObject() as UITouch
        let pnt = touch.locationInView(self)
        points.append(pnt)
        if points.count > 1 {
            myPath.moveToPoint(pnt)
        } else {
            myPath.addLineToPoint(pnt)
        }
        println("touch added")
        self.setNeedsDisplay()
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        touchesBegan(touches,withEvent: event)
    }
    
}
