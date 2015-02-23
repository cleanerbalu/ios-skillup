//
//  MyTableView.swift
//  Recipes
//
//  Created by Davit on 2.23.15.
//  Copyright (c) 2015 Davit. All rights reserved.
//

import UIKit

class MyTableView: UITableView {
    //var locations
    override func drawRect(rect: CGRect) {
        UIColor.redColor().setStroke()
        var testPath = UIBezierPath()
        testPath.lineWidth = 10.0
        testPath.moveToPoint(CGPoint(x: 0,y: 0))
        testPath.addLineToPoint(CGPoint(x: 100,y: 100))
        testPath.stroke()
        println("drawRect \(rect)")
        
    }
    
    
}
