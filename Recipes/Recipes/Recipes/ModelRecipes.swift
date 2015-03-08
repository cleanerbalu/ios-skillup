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
import CoreLocation

private var managedObjectModel: NSManagedObjectModel?
private var managedObjectContext: NSManagedObjectContext?
private var persistentStoreCoordinator: NSPersistentStoreCoordinator?
private var appDelegate: UIApplicationDelegate?
private var _fetchedResultsController: NSFetchedResultsController? = nil
private var _filterShortName: String? = nil
private var _sortOrderAsc = false

class ModelRecipes {
    struct recipeDataType {
        var shortDescribtion: String? = nil
        var preparation: String? = nil
        var image: UIImage? = nil
        var coords: CLLocationCoordinate2D? = nil
    }
    
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
            //println("sqlURL \(sqlURL)")
            var error: NSError? = nil
            var failureReason = "There was an error creating or loading the application's saved data."
            
            if persistentStoreCoordinator?.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: sqlURL, options: nil, error: &error) == nil {
                persistentStoreCoordinator = nil
                let dict = NSMutableDictionary()
                dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
                dict[NSLocalizedFailureReasonErrorKey] = failureReason
                dict[NSUnderlyingErrorKey] = error
                error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
                NSLog("Unresolved error \(error), \(error!.userInfo)")
                abort()
            }
   
            managedObjectContext = NSManagedObjectContext()
            managedObjectContext?.persistentStoreCoordinator = persistentStoreCoordinator
            
            NSFetchedResultsController.deleteCacheWithName("Master")
        }
        
    }
    
    
    
    
    func removeSavedFile(object: NSManagedObject) {
        if let obj: AnyObject = object.valueForKey("imageLocation") {
            let filePath = "\(glPicturePath)/\(obj.description)"
            var error: NSError?
            if NSFileManager.defaultManager().removeItemAtPath(filePath, error: &error) {
                //println("File removed \(filePath)")
            } else {
                NSLog("Error remove file: \(error!.localizedDescription)")
            }
        }
    }
    
    func removeFromFetchedResults(atIndexPath indexPath: NSIndexPath) {
        if _fetchedResultsController != nil {
            let object = _fetchedResultsController?.objectAtIndexPath(indexPath) as NSManagedObject
            removeSavedFile(object)
            managedObjectContext?.deleteObject(object)
            saveContext()
        }
    }
    
    
    private func rerequest() {
        NSFetchedResultsController.deleteCacheWithName("Master")
        var error: NSError? = nil
        if !_fetchedResultsController!.performFetch(&error) {
            abort()
        }
    }
    private func getPredicate() -> NSPredicate? {
        var predicate: NSPredicate? = nil
        if let shrtName = _filterShortName {
            if shrtName != "" {
                predicate = NSPredicate(format: "shortDescr contains[c] %@", shrtName)
            }
        }
        return predicate
    }
    

    var  sortOrderAscending: Bool {
        get {
            return  _sortOrderAsc
        }
        set {
            _sortOrderAsc = newValue
            if let fRC = _fetchedResultsController {
                fRC.fetchRequest.sortDescriptors = [NSSortDescriptor(key: "shortDescr", ascending: _sortOrderAsc)]
                rerequest()
            }
        }
    }
    var  filterShortName: String? {
        get{
            return _filterShortName
        }
        set {
            _filterShortName = newValue
            if let fRC = _fetchedResultsController {
                fRC.fetchRequest.predicate = getPredicate()
                rerequest()
            }
        }
    }
    
    
    var fetchedResultsController: NSFetchedResultsController {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let fetchRequest = NSFetchRequest()
        // Edit the entity name as appropriate.
        let entity = NSEntityDescription.entityForName("TheRecipe", inManagedObjectContext: managedObjectContext!)
        fetchRequest.entity = entity
        fetchRequest.fetchBatchSize = 20
        
        // Edit the sort key as appropriate.
        let sortDescriptor = NSSortDescriptor(key: "shortDescr", ascending: _sortOrderAsc)
        
        //let sortDescriptors = [sortDescriptor]
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchRequest.predicate = getPredicate()
        
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext!, sectionNameKeyPath: nil, cacheName: "Master")
        _fetchedResultsController = aFetchedResultsController
        
        var error: NSError? = nil
        if !_fetchedResultsController!.performFetch(&error) {
             abort()
        }
        
        return _fetchedResultsController!
    }
    
    func insertNewOrEditObject(object: NSManagedObject?, recipe: recipeDataType, imageChanged: Bool) {
        let context = fetchedResultsController.managedObjectContext
        var fileName: String? = nil
        var newManagedObject: NSManagedObject? = nil
        var updateImage = true
        
        if let obj = object {
            println("edit object")
            if imageChanged {
                removeSavedFile(obj)
            } else {
                updateImage = false
            }
            newManagedObject = obj
        } else {
            newManagedObject = NSEntityDescription.insertNewObjectForEntityForName("TheRecipe", inManagedObjectContext: context) as? NSManagedObject
        }
        
        
        if recipe.image != nil && imageChanged {
            var imageData = UIImagePNGRepresentation(recipe.image)
            let fileManager = NSFileManager.defaultManager()
            let uuid = NSUUID().UUIDString
            fileName = "recipe\(uuid).png"
            let filePathToWrite = "\(glPicturePath)/\(fileName!)"
            fileManager.createFileAtPath(filePathToWrite, contents: imageData, attributes: nil)
        } else {
            
        }
        
        var locPresent = false
        if let theCoord = recipe.coords {
            newManagedObject?.setValue(recipe.coords?.longitude, forKey: "crdLon")
            newManagedObject?.setValue(recipe.coords?.latitude, forKey: "crdLat")
            locPresent = true
        }
        newManagedObject?.setValue(locPresent, forKey: "isLocationPresent")
        newManagedObject?.setValue(recipe.shortDescribtion, forKey: "shortDescr")
        newManagedObject?.setValue(recipe.preparation, forKey: "preparation")
        if updateImage {
            newManagedObject?.setValue(fileName, forKey: "imageLocation")
        }
        
        // Save the context.
        var error: NSError? = nil
        if !context.save(&error) {
            abort()
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
  
}