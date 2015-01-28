//
//  ImageContainer.swift
//  Demo
//
//  Created by Davit on 1.28.15.
//  Copyright (c) 2015 Oleh Sannikov. All rights reserved.
//

import Foundation
import UIKit

private var images: Array<UIImage>? = nil
private func loadDataImages() -> Array<UIImage> {
    println("ImageContainer.loadDataImages()")
    var result = Array<UIImage>()
    
    for var i = 0; i < 19; i++ {
        let image = UIImage(named: "sa\(i).jpg")
        result.append(image!)
    }
    return result
}


class ImageContainer {
     //= self.loadDataImages()
    init(){
        println("ImageContainer.init()")
        if images == nil {
            images = loadDataImages()
        }
    }
     subscript (index: Int) ->UIImage? {
        get {
            if let img = images {
                return img[index]
            } else {
                return nil
            }
            
        }
     }
    
     var count: Int {
        if let img = images {
            return img.count
        } else {
            return 0
        }
        
     }
    
    
}