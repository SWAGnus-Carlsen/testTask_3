//
//  CoreDataManager.swift
//  CarsTestTask
//
//  Created by Vitaliy Halai on 26.12.23.
//

import Foundation
import CoreData

final class CoreDataManager {
    
    //MARK: Singleton
    static let shared = CoreDataManager()
    
    //MARK: Constructor
    private init() { }
    
    // MARK: Core Data stack
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CarsTestTask")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: Core Data Saving support
    func saveContext () {
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
    
    func getSavedData() -> [Car] {
        let carFetchRequest = Car.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "year", ascending: true)
        carFetchRequest.sortDescriptors = [sortDescriptor]
        let result = try? context.fetch(carFetchRequest)
        return result ?? []  
    }
    
    func delete(_ car: Car) throws {
        context.delete(car)
        guard context.hasChanges else { return }
        try context.save()
    }
}
