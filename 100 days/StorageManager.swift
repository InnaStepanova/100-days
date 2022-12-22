//
//  StorageManager.swift
//  100 days
//
//  Created by Лаванда on 22.12.2022.
//

import Foundation
import CoreData

class StorageManager{
    static let shared = StorageManager()
    private init(){}
    
    lazy var persistentContainer: NSPersistentContainer = {
       
        let container = NSPersistentContainer(name: "_00_days")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    private var context: NSManagedObjectContext{
        return persistentContainer.viewContext
    }

    func fetchDreams() -> [Dream] {
        let fetchRequest: NSFetchRequest<Dream> = Dream.fetchRequest()
        do {
            return try context.fetch(fetchRequest)
        } catch let error {
            print("Failed to fetch data", error)
            return[]
        }
    }
    
    func save(newDream: String, completion: (Dream) -> Void) {
        guard let entityDescriptions = NSEntityDescription.entity(forEntityName: "Dream", in: context) else {return}
        
        let dream = NSManagedObject(entity: entityDescriptions, insertInto: context) as! Dream
        dream.name = newDream
        dream.dayOfStart = Date()
        dream.dayNumber = 1
        completion(dream)
        saveContext()
    }
    
    func edit(_ dream: Dream, editDream: String) {
        dream.name = editDream
        saveContext()
    }
    
    func delete(_ dream: Dream) {
        context.delete(dream)
        saveContext()
    }
    
    func saveContext () {
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
