//
//  ViewController.swift
//  Dictionary
//
//  Created by Oleh Sannikov on 18.01.15.
//  Copyright (c) 2015 Oleh Sannikov. All rights reserved.
//

import UIKit


class TableViewController: UIViewController, UITableViewDataSource, UISearchBarDelegate, UIAlertViewDelegate {

    @IBOutlet var tableView: UITableView?
    @IBOutlet var searchBar: UISearchBar?
    @IBOutlet var toolBar: UIToolbar?
    
    private lazy var alphabet = Alphabet()
    private lazy var wordsReference = WordsReference()
    private var filteredWords: [WordsReference.Word]?
    
    private var isAlphabetMode: Bool = false {
        didSet (newValue) {
            if newValue != isAlphabetMode {
                //animateSwitch()

                tableView?.reloadData()
                tableView?.setContentOffset(CGPointMake(0, isAlphabetMode ? 44 : 0), animated: true)
                searchBar?.resignFirstResponder()
/*
                UIView.beginAnimations("switch", context: nil)
                UIView.setAnimationDuration(1)
                UIView.setAnimationRepeatAutoreverses(true)
                UIView.setAnimationRepeatCount(1)
                
                toolBar?.transform = CGAffineTransformMakeScale(0.5,0.5)
                UIView.commitAnimations()
                toolBar?.transform = CGAffineTransformMakeScale(1,1)*/
                /*
                UIView.animateWithDuration(1.0, delay: 0.0, usingSpringWithDamping: CGFloat(0.3), initialSpringVelocity: CGFloat(3.0), options: UIViewAnimationOptions.CurveEaseInOut,
                    animations:({
                        self.toolBar?.transform = CGAffineTransformMakeScale(0.5, 0.5)
                }), completion: nil)
                */
                
                UIView.animateWithDuration(1.0, delay: 0.0, usingSpringWithDamping: 0.3,
                                            initialSpringVelocity: 3.0, options: UIViewAnimationOptions.CurveEaseInOut,
                    animations: ({
                        self.toolBar!.transform = CGAffineTransformMakeScale(0.5, 0.5)
                    }),
                    completion: { finished in
                        self.toolBar!.transform = CGAffineTransformMakeScale(1, 1)
                })
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "appChangedState", name: UIApplicationWillResignActiveNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "appChangedState", name: UIApplicationWillTerminateNotification, object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func appChangedState() {
        wordsReference.saveChanges()
    }
    
    //MARK: TableView datasource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isAlphabetMode ? alphabet.letters.count : (filteredWords != nil ? filteredWords!.count : wordsReference.words.count)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId = isAlphabetMode ? "alphabetCell" : "dictionaryCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath) as UITableViewCell
        
        if isAlphabetMode {
            let alphabetCell = cell as AlphabetCell
            let letter = alphabet.letters[indexPath.row]
            
            let color = letter.isVowel ?  UIColor.blueColor() : UIColor.blackColor()
            
            alphabetCell.sourceLetter?.text = String(letter.char)
            alphabetCell.transcript?.text = letter.transcript
            alphabetCell.ipaTranscript?.text = letter.ipaTranscript
            
            [alphabetCell.sourceLetter, alphabetCell.transcript, alphabetCell.ipaTranscript].map({ $0?.textColor = color})
        }
        else {
            let word = filteredWords != nil ? filteredWords![indexPath.row] : wordsReference.words[wordsReference.wordsIndex[indexPath.row]]
            var translations = ", ".join(word!.translations)
            cell.textLabel?.text = " - ".join([word!.word, translations])
        }
        
        return cell
    }

    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        
        if isAlphabetMode {
            return false
        } else {
            let word = wordsReference.wordsIndex[indexPath.row]
            return wordsReference.canDeleteWord(word)
        }
        
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            wordsReference.deleteWord(wordsReference.wordsIndex[indexPath.row])
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    //MARK: Search bar
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        filteredWords = searchText.utf16Count > 0 ? wordsReference.search(searchText) : nil
        tableView?.reloadData()
    }
    
    //MARK: AlertView
    func alertView(alertView: UIAlertView, didDismissWithButtonIndex buttonIndex: Int) {
        if buttonIndex == 1 {
            if let textField = alertView.textFieldAtIndex(0) {
                let defString = textField.text.stringByReplacingOccurrencesOfString("/[ ]*[-][ ]*/g", withString:" - ", options: .RegularExpressionSearch)
                let strings = defString.componentsSeparatedByString(" - ")
                
                if strings.count >= 2 {
                    let word = strings[0].stringByReplacingOccurrencesOfString(" ", withString: "")
                    let translations = strings[1].stringByReplacingOccurrencesOfString("/[ ]*[,][ ]*/g", withString:" - ", options: .RegularExpressionSearch).componentsSeparatedByString(",")
                    
                    if translations.count > 0 {
                        wordsReference.addWord(WordsReference.Word(word: word, translations: translations))
                        tableView?.reloadData()
                    }
                }
            }
        }
    }
    
    //MARK: Actions
    @IBAction func onSegmentedControl(sender: AnyObject) {
        
        if let segmentedControl = sender as? UISegmentedControl {
            isAlphabetMode = segmentedControl.selectedSegmentIndex == 1
        }
        
        
    }
    
    @IBAction func onTap(sender: AnyObject) {
        searchBar?.resignFirstResponder()
    }
    
    @IBAction func onEdit(sender: AnyObject) {
        if let editButton = sender as? UIBarButtonItem {
            tableView?.editing = tableView == nil || !tableView!.editing
            editButton.title = NSLocalizedString(tableView != nil && tableView!.editing ? "Done" : "Edit", comment:"")
        }
    }
    
    @IBAction func onAdd(sender: AnyObject) {
        let alertView = UIAlertView(title: "Add new word", message: "In the form: გამარჯობა - hi, hello", delegate: self, cancelButtonTitle: NSLocalizedString("Cancel", comment:""), otherButtonTitles: NSLocalizedString("OK", comment:""))
        alertView.alertViewStyle = .PlainTextInput
        
        alertView.show()
    }
    
    //MARK:
    func animateSwitch() {
        /*
        let imageView = UIImageView(image: UIImage(named: isAlphabetMode ? "letter.png" : "dictionary.png"))
        imageView.center = view!.center
        imageView.alpha = 0
        self.tableView!.alpha = 0
        view.addSubview(imageView)
        
        UIView.animateWithDuration(1, animations: {
                imageView.alpha = 1
            }, completion: {
            (result) -> Void in

            UIView.animateWithDuration(1, animations: {imageView.alpha = 0}, completion: {
                (result) -> Void in
                self.tableView!.alpha = 1
                imageView.removeFromSuperview()
            })
            
            return
        })
*/
 
    }
}

