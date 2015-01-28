//
//  BaseCollectionViewController.swift
//  Demo
//
//  Created by Oleh Sannikov on 26.01.15.
//  Copyright (c) 2015 Oleh Sannikov. All rights reserved.
//

import UIKit

let reuseIdentifier = "Cell"


class BaseCollectionViewController: UICollectionViewController {
    //lazy var images: Array<UIImage> = self.loadDataImages()
    var  images = ImageContainer()
    var selectedIndex: Int = 0

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("imageCell", forIndexPath: indexPath) as CollectionViewCell
        cell.image?.image = self.images[indexPath.row]
        
        return cell
    }
    
   
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        self.performSegueWithIdentifier("goToGrid", sender: self)
    }
    
    // MARK:
    func loadDataImages() -> Array<UIImage> {
        var result = Array<UIImage>()
        
        for var i = 0; i < 19; i++ {
            let image = UIImage(named: "sa\(i).jpg")
            result.append(image!)
        }
        return result
    }
    
}
