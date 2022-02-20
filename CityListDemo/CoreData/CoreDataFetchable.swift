//
//  CoreDataFetchable.swift
//  CityListDemo
//
//  Created by ChungTing on 2022/2/17.
//

import Foundation
import CoreData

protocol CoreDataFetchable {}

extension CoreDataFetchable {
    func getAllFromCache<T: NSManagedObject>(entity: T.Type) -> [NSFetchRequestResult] {
        do {
            let items = try CoreDataManager.shared.mainContext.fetch(T.fetchRequest())
            return items
        }
        catch {
            print("An error \(error.localizedDescription) occurred when fetching the \(T.Type.self) Core Data")
            return []
        }
    }
    
    func getCachedElement(by request: NSFetchRequest<NSFetchRequestResult>) -> NSFetchRequestResult? {
        do {
            let requests = try CoreDataManager.shared.mainContext.fetch(request)
            guard let matchedItem = requests.first else {
                return nil
            }
            return matchedItem
        } catch {
            print("An error \(error.localizedDescription) occurred when fetching the \(request) Core Data")
            return nil
        }
    }
    
    func save() {
        do {
            try CoreDataManager.shared.mainContext.save()
        } catch {
            print("An error \(error.localizedDescription) occurred when saving the Core Data")
        }
    }

    func clear(entityName: String) throws {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entityName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        try CoreDataManager.shared.mainContext.execute(deleteRequest)
    }
}

