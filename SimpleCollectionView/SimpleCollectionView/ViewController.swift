//
//  ViewController.swift
//  SimpleCollectionView
//
//  Created by Oleh Sannikov on 25.01.15.
//  Copyright (c) 2015 Oleh Sannikov. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController {
    var images = Array<UIImageView>()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        loadImages()
        
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("imageCell", forIndexPath: indexPath) as ImageCellCollectionViewCell
        
        cell.vwimage =  images[indexPath.row]
        return cell
    }
    
    func loadImages() {
        for var i = 0; i < 19; i++ {
            let image = UIImage(named: "sa\(i).jpg")
            let imgView =   UIImageView()
            imgView.image = image
            images.append(imgView)
        }
    }
    
 /*   override func collectionView(collectionView: UICollectionView, didHighlightItemAtIndexPath indexPath: NSIndexPath)
    {
        super.
        //let myimage =  images[indexPath.row] as ImageCellCollectionViewCell
        //myimage.myDraw()
    }*/
}

