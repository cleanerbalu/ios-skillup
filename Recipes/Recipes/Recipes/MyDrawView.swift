//
//  MyTableView.swift
//  Recipes
//
//  Created by Davit on 2.23.15.
//  Copyright (c) 2015 Davit. All rights reserved.
//

import UIKit

class MyDrawView: UIView {
    struct BezierColor {
        let myPath: UIBezierPath
        let color: UIColor
    }
    var myPicture = [BezierColor]()
    
    var currentPath: BezierColor?
    var currentWidth: Float = 2.0
    var color: UIColor
    
    override init() {
        myPicture = []
        color = UIColor.blackColor()
        super.init()
    }
    
    required init(coder aDecoder: NSCoder) {
        myPicture = []
        color = UIColor.blackColor()
        super.init(coder: aDecoder)
    }
    override func drawRect(rect: CGRect) {
        color.setStroke()
        for pict in myPicture {
            pict.color.setStroke()
            pict.myPath.stroke()
        }
        if let cur = currentPath {
            cur.color.setStroke()
            cur.myPath.stroke()
        }
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        let touch = touches.anyObject() as UITouch
        let pnt = touch.locationInView(self)
        
        
        currentPath = BezierColor(myPath: UIBezierPath(),color: color)
        currentPath?.myPath.moveToPoint(pnt)
        currentPath?.myPath.lineWidth = CGFloat(currentWidth)
        self.setNeedsDisplay()
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        let touch = touches.anyObject() as UITouch
        let pnt = touch.locationInView(self)
        
        currentPath?.myPath.addLineToPoint(pnt)
        self.setNeedsDisplay()
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
         myPicture.append(currentPath!)
        currentPath = nil
        self.setNeedsDisplay()
    }
    
    func setCurrentColor(newColor: UIColor){
        color = newColor
    }
    
    func undoLine() {
        if myPicture.count>0 {
            myPicture.removeLast()
            self.setNeedsDisplay()
        }
    }
    
    func clear() {
        myPicture = []
        self.setNeedsDisplay()
    }
    
    func increaseLine(){
        if currentWidth<15  {
            currentWidth++
        }
        
    }
    func decreaseLine() {
        if currentWidth>1 {
            currentWidth--
        }
        
    }
    func getLine() -> Int {
        return Int(currentWidth)
    }
    
    func getCurrentColor() -> UIColor{
        return color
     }
}
