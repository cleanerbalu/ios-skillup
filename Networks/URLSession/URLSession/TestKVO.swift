//
//  TestKVO.swift
//  URLSession
//
//  Created by User-3 on 2/5/15.
//  Copyright (c) 2015 User-3. All rights reserved.
//

import Foundation

class TestKVO: NSObject{
    dynamic var key = "Init"
    func setKey(data: String) {
        key = data
    }
}