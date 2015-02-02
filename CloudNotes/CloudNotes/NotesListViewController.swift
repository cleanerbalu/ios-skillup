//
//  NotesListViewController.swift
//  CloudNotes
//
//  Created by Oleh Sannikov on 02.02.15.
//  Copyright (c) 2015 Oleh Sannikov. All rights reserved.
//

import UIKit
import ParseUI
import Parse

class NotesListViewController: PFQueryTableViewController {
    @IBOutlet  weak var myNote: UITextField?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.parseClassName = "Note"
    }
    
    override func viewDidLoad() {
        if let user = PFUser.currentUser() {
            println("logged in as: \(user)")
        } else {
            performSegueWithIdentifier("login", sender: self)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.loadObjects()
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject) -> PFTableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as PFTableViewCell
        cell.textLabel.text = object.objectForKey("title") as? String
        return cell
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "details" {
            
        }
    }
    
    override func queryForTable() -> PFQuery! {
        let query = PFQuery(className: self.parseClassName)
        if let user = PFUser.currentUser() {
            query.whereKey("author", equalTo: user)
        }
        return query
    }

    @IBAction func addNote(sender: AnyObject) {
        
        //let askUser = UIAlertController(
        var ok = false
        if let thenote = myNote?.text {
            
            if (thenote != "") {
                let note = PFObject(className: "Note")
                println("\(thenote)")
                note["title"] = thenote
                note["author"] = PFUser.currentUser()
            
                note.saveInBackgroundWithBlock { (result, error) -> Void in
                if result {
                    self.loadObjects()
                }
                }
                ok = true
            }
        } 
        if !ok {
            let alr = UIAlertView(title: "Error", message: "Please input data", delegate: self, cancelButtonTitle: "I'got it")
        }
    }
    
    @IBAction func logOut(sender: AnyObject) {
        let res = PFUser.logOut()
        self.performSegueWithIdentifier("login", sender: self)
    }
}
