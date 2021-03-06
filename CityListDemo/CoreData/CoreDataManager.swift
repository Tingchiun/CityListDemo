//
//  CoreDataManager.swift
//  CityListDemo
//
//  Created by ChungTing on 2022/2/13.
//

import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    private init() {}
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CityDataModel")
        container.loadPersistentStores(completionHandler: { _, error in
            _ = error.map { fatalError("Unresolved error \($0)") }
        })
        return container
    }()
        
    var mainContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
}
