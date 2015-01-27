//
//  GridCollectionViewController.swift
//  Demo
//
//  Created by Oleh Sannikov on 26.01.15.
//  Copyright (c) 2015 Oleh Sannikov. All rights reserved.
//

import UIKit

class GridCollectionViewController: BaseCollectionViewController {
    var imgPos: Int = 0;
    
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        imgPos = indexPath.row
        self.performSegueWithIdentifier("goToDetail", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier=="goToDetail" {
            let dst = segue.destinationViewController as DetailsViewController
            dst.image = self.images[imgPos]
            
        }
    }
    
    
}
