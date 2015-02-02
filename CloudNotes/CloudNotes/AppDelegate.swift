//
//  AppDelegate.swift
//  CloudNotes
//
//  Created by Oleh Sannikov on 02.02.15.
//  Copyright (c) 2015 Oleh Sannikov. All rights reserved.
//

import UIKit
import Parse

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        Parse.setApplicationId("z00NgyILoi9WzZAjU3Nf75In2sFGbuVoACp4zBvm", clientKey: "boc8dprDnPIV1LwnbUl5ASYHI4pmm5dL1QlZYCnv")
        return true
    }
    
    //parse.com

}

