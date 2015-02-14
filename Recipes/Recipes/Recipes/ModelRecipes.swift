//
//  DataModel.swift
//  Recipes
//
//  Created by Davit on 2/14/15.
//  Copyright (c) 2015 Davit. All rights reserved.
//

import Foundation
import UIKit
import CoreData


private var managedObjectModel: NSManagedObjectModel?
private var managedObjectContext: NSManagedObjectContext?
private var persistentStoreCoordinator: NSPersistentStoreCoordinator?
private var appDelegate: UIApplicationDelegate?

class ModelRecipes {
    
    init(){
        if managedObjectContext == nil {
            /*load the model*/
            let modelURL = NSBundle.mainBundle().URLForResource("Recipe", withExtension: "momd")
            managedObjectModel = NSManagedObjectModel(contentsOfURL: modelURL!);
            
            /*store location*/
            persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel!)
            
            /*get app dir*/
            let appURLs = NSFileManager.defaultManager().URLsForDirectory( .DocumentDirectory, inDomains: .UserDomainMask)
            let docsDirURL = appURLs[appURLs.count-1] as NSURL
            let sqlURL = docsDirURL.URLByAppendingPathComponent("recipe.sqlite")
            
            var error: NSError? = nil
            var failureReason = "There was an error creating or loading the application's saved data."
            
            if persistentStoreCoordinator?.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: sqlURL, options: nil, error: &error) == nil {
                persistentStoreCoordinator = nil
                let dict = NSMutableDictionary()
                dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
                dict[NSLocalizedFailureReasonErrorKey] = failureReason
                dict[NSUnderlyingErrorKey] = error
                error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
                // Replace this with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                NSLog("Unresolved error \(error), \(error!.userInfo)")
                abort()
            }
   
            managedObjectContext = NSManagedObjectContext()
            managedObjectContext?.persistentStoreCoordinator = persistentStoreCoordinator
        }
        
    }
    
    func saveContext () {
        if let moc = managedObjectContext {
            var error: NSError? = nil
            if moc.hasChanges && !moc.save(&error) {
                NSLog("Unresolved error \(error), \(error!.userInfo)")
                abort()
            }
        }
    }
    /*
    subscript(index: Int) ->theRecipe? {
        get {
            if let dt = data {
                //return dt[index]
            } else {
                return nil;
            }
        }
    
    }
    
    var count: Int {
        if let dt = data {
            return dt.count
        } else {
            return 0;
        }
    }
    
    func addRecipe(description: String, preparation: String, img:UIImage) {
        //let rcp = theRecipe(description: description, preparation: preparation, picture: img)
        //data?.append(rcp)
    }
*/
}