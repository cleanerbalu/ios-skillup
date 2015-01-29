//
//  ViewController.swift
//  URLSession
//
//  Created by User-3 on 1/29/15.
//  Copyright (c) 2015 User-3. All rights reserved.
//

import UIKit

class ViewController: UIViewController,NSURLSessionDelegate {
    @IBOutlet var web: UIWebView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //https ://ht tpbin.
        
        println("I'm here")
        let urlcon = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        let nsurl = NSURLSession(configuration: urlcon, delegate:self, delegateQueue: nil)
        let theURL = NSURL(string:"https://googlu.com")
        nsurl.dataTaskWithURL(theURL!,
            completionHandler: {
                (data: NSData!, resp: NSURLResponse!, err: NSError!) -> Void in
                var res: Int = 0
                if let err = err {
                    res = err.code
                }
        
                if res == 0 {
                    println(data)
                    let mime = "text/html"
            
                    self.web?.loadData(data!, MIMEType: mime, textEncodingName: "utf-8", baseURL: theURL!)
                } else {
                    let alrt = UIAlertView(title: "Error", message: "The code \(res)", delegate: nil, cancelButtonTitle: "Cancel")
                    alrt.show()
                    println("Error \(res)")
                }
        }).resume()
 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    


}

