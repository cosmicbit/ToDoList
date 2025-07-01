//
//  CoreDataStack.swift
//  ToDoList
//
//  Created by Philips on 01/07/25.
//

import Foundation
import CoreData

class CoreDataStack {
    
    private let modelName: String
    lazy var managedContext: NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()
    
    init(modelName: String) {
        self.modelName = modelName
    }

    // Create a persistent container as a lazy variable to defer instantiation until its first use.
    lazy var persistentContainer: NSPersistentContainer = {
        
        // Pass the data model filename to the container’s initializer.
        let container = NSPersistentContainer(name: "ToDoList")
        
        // Load any persistent stores, which creates a store if none exists.
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                // Handle the error appropriately. However, it's useful to use
                // `fatalError(_:file:line:)` during development.
                fatalError("Unresolved Error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    //MARK: - Core Data Saving Support
    func saveContext() {
        
        if managedContext.hasChanges {
            do {
                try managedContext.save()
                
            }catch {
                let nserror = error as NSError
                fatalError("Unresolved Error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
