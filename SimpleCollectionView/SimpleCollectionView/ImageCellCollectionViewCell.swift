//
//  ImageCellCollectionViewCell.swift
//  SimpleCollectionView
//
//  Created by Oleh Sannikov on 25.01.15.
//  Copyright (c) 2015 Oleh Sannikov. All rights reserved.
//

import UIKit

class ImageCellCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var vwimage: UIImageView!
    
    func myDraw (){
        let rct = UIView(frame: CGRect(x: 0,y: 0,width: 10,height: 10))
        rct.backgroundColor = UIColor.greenColor()
     
        vwimage.addSubview(rct)
    }
}
