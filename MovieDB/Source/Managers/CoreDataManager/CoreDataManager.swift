//
//  CoreDataManager.swift
//
//  Created by Giorgi Iashvili on 8/16/19.
//  Copyright © 2019 Giorgi Iashvili. All rights reserved.
//

import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    let globalQueue = DispatchQueue(label: "label_core_data_manager_global_queue")
    
    private let managedObjectContextKey = "key_core_data_manager_managed_object_context"
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MovieDB")
        container.loadPersistentStores(completionHandler: { storeDescription, error in
            if let error = error
            {
                print("Persistent stores load failed with error: \(error.localizedDescription)")
            }
        })
        return container
    }()
    
    var context: NSManagedObjectContext
    {
        get
        {
            let context = Thread.current.threadDictionary[self.managedObjectContextKey] as? NSManagedObjectContext ?? self.createNewContext()
            Thread.current.threadDictionary[self.managedObjectContextKey] = context
            return context
        }
    }
    
    private func createNewContext() -> NSManagedObjectContext
    {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.persistentStoreCoordinator = self.persistentContainer.persistentStoreCoordinator
        context.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        return context
    }
    
}
