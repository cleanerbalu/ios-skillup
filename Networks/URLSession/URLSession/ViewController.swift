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
    let kv = TestKVO()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //https ://ht tpbin.
        
        
        
        
        let nc = NSNotificationCenter.defaultCenter()
        nc.addObserver(self,selector:"receive:",name:"test",object:nil)
        nc.postNotificationName ("test", object: nil)
        
        kv.addObserver(self, forKeyPath: "key", options: nil, context: nil)
        kv.setKey("newData")
        kv.setKey("again newData")
        
        
        
        let sett = UIUserNotificationSettings(forTypes: UIUserNotificationType.Badge, categories: nil)
        let local = UILocalNotification()
        local.fireDate = NSDate(timeIntervalSinceNow: 5)
        //local.applicationIconBadgeNumber = 4
        let myApp = UIApplication.sharedApplication()
        myApp.registerUserNotificationSettings(sett)
        myApp.scheduleLocalNotification(local)
        
        
        
        
        
        
        println("I'm here")
        let urlcon = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        let nsurl = NSURLSession(configuration: urlcon, delegate:self, delegateQueue: nil)
        let theURL = NSURL(string:"https://google.com")
        nsurl.dataTaskWithURL(theURL!,
            completionHandler: {
                (data: NSData!, resp: NSURLResponse!, err: NSError!) -> Void in
                var res: Int = 0
                if let err = err {
                    res = err.code
                }
        
                if res == 0 {
                    let mime = "text/html"
            
                    self.web?.loadData(data!, MIMEType: mime, textEncodingName: "utf-8", baseURL: theURL!)
                } else {
                    let alrt = UIAlertView(title: "Error", message: "The code \(res)", delegate: nil, cancelButtonTitle: "Cancel")
                    alrt.show()
                    println("Error \(res)")
                }
        }).resume()
 
    }

    func receive(data: NSNotification){
         println("received")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        println((object as TestKVO).key)
    }


}

