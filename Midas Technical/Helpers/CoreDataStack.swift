//
//  CoreDataStack.swift
//  Midas Technical
//
//  Created by Tb. Daffa Amadeo Zhafrana on 08/03/23.
//

import Foundation
import CoreData

class CoreDataStack {
    
    // Singleton instance for the core data stack
    static let shared = CoreDataStack()
    
    // Managed object context for the core data stack
    let persistentContainer: NSPersistentContainer
    
    private init() {
        // Initialize the persistent container with the data model name
        persistentContainer = NSPersistentContainer(name: "Midas_Technical")
        
        // Load the persistent store asynchronously
        persistentContainer.loadPersistentStores { (storeDescription, error) in
            if let error = error {
                fatalError("Failed to load persistent store: \(error)")
            }
        }
    }
    
    // Save the managed object context
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}


