//
//  MyTableView.swift
//  Recipes
//
//  Created by Davit on 2.23.15.
//  Copyright (c) 2015 Davit. All rights reserved.
//

import UIKit

class MyDrawView: UIView {
    var myPath = [UIBezierPath()]
    var currentPath: UIBezierPath?
    override init() {
        myPath = []
        super.init()
    }
    
    required init(coder aDecoder: NSCoder) {
        myPath = []
        super.init(coder: aDecoder)
    }
    override func drawRect(rect: CGRect) {
        UIColor.redColor().setStroke()
        for path in myPath {
            path.stroke()
        }
        if let cur = currentPath {
            cur.stroke()
        }
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        let touch = touches.anyObject() as UITouch
        let pnt = touch.locationInView(self)
        currentPath = UIBezierPath()
        currentPath?.moveToPoint(pnt)
        self.setNeedsDisplay()
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        let touch = touches.anyObject() as UITouch
        let pnt = touch.locationInView(self)
        currentPath?.addLineToPoint(pnt)
        self.setNeedsDisplay()
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        myPath.append(currentPath!)
        self.setNeedsDisplay()
    }
    
}
