//
//  ViewController.swift
//  ObjectSwift
//
//  Created by User-3 on 2/19/15.
//  Copyright (c) 2015 User-3. All rights reserved.
//

import UIKit
//import SVPullToRefresh

class ViewController: UIViewController {

    @IBOutlet weak var scrollview: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        scrollview.addPullToRefreshWithActionHandler({return })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

