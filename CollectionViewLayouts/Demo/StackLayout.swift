//
//  StackLayout.swift
//  Demo
//
//  Created by Oleh Sannikov on 25.01.15.
//  Copyright (c) 2015 Oleh Sannikov. All rights reserved.
//

import UIKit

class StackLayout: UICollectionViewLayout {

    var stackCount = 5
    var itemSize = CGSize(width:320, height:240)
    var angles = Array<Float>()
    var attributesArray = Array<UICollectionViewLayoutAttributes>()
    
    func myrand(min: Float,max: Float) -> Float {
        return Float(rand()) / Float(RAND_MAX) * (max-min) + min
    }
    
    override func prepareLayout() {
        srand(42)
        
        let size = self.collectionView!.bounds.size
        let center = CGPointMake(size.width / 2.0, size.height / 2.0);
        let itemCount = self.collectionView!.numberOfItemsInSection(0)
        
        angles.removeAll()
        
        let maxAngle = Float(M_1_PI / 3.0)
        let minAngle = Float(-M_1_PI / 3.0)
        let diff = maxAngle - minAngle
        
        angles.append(0.0)
        for var i = 1; i < self.stackCount * 10; i++ {
            let currentAngle = Float(rand()) / Float(RAND_MAX) * diff + minAngle
            angles.append(currentAngle)
        }
        
        for var i = 1; i < itemCount; i++ {
            let angleIndex = i % (self.stackCount * 10)
            let angle = angles[angleIndex]
            
            let indexPath = NSIndexPath(forRow:i, inSection:0)
            let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath:indexPath)
            
            attributes.size = self.itemSize
            attributes.center = center
            //attributes.transform = CGAffineTransformMakeRotation(CGFloat(angle))
            attributes.transform = CGAffineTransformMakeRotation(CGFloat(angle))
                                   /*CGAffineTransformScale(
                                        CGAffineTransformTranslate(
                                            CGAffineTransformMakeRotation(CGFloat(angle)),
                                        CGFloat(myrand(-100,max: 300)),
                                        CGFloat(myrand(-100,max: 300))),
                                    CGFloat(myrand(-0.2,max: 0.5)),
                                    CGFloat(myrand(-0.2,max: 0.5)))*/
            
            attributes.alpha = i > self.stackCount ? 0.0 : 1.0
            attributes.zIndex = itemCount - 1
            
            self.attributesArray.append(attributes)
        }
    }
    
    override func invalidateLayout() {
        super.invalidateLayout()
        attributesArray.removeAll()
    }

    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        let bounds = self.collectionView!.bounds
        return (newBounds.width != bounds.width) || (newBounds.height != bounds.height)
    }
    
    override func collectionViewContentSize() -> CGSize {
        return self.collectionView!.bounds.size
    }
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        return indexPath.row < self.attributesArray.count ? self.attributesArray[indexPath.row] : nil
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject]? {
        return self.attributesArray
    }
}