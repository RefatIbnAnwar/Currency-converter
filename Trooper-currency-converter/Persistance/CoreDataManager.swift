//
//  CoreDataManager.swift
//  Trooper-currency-converter
//
//  Created by Md Refat Hossain on 17/06/2025.
//

import Foundation
import CoreData
import UIKit

extension LatestRateEntity {
}

class CoreDataManager {
    
    
    static let shared = CoreDataManager()
    private init() {}
    
    //  Persistent Container
    var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Trooper_currency_converter")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Core Data load error: \(error)")
            }
        }
        return container
    }()
    
    // Context
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // Save Context
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Core Data save error: \(error)")
            }
        }
    }
    
    // Save LatestRateModel
    func saveLatestRate(_ model: LatestRateModel) {
        let entity = LatestRateEntity(context: context)
        entity.success = model.success
        entity.timestamp = Int64(model.timestamp)
        entity.base = model.base
        entity.date = model.date
        
        do {
            entity.rates = try JSONEncoder().encode(model.rates)
            saveContext()
            print("Saved LatestRateModel to Core Data")
        } catch {
            print("Encoding rates failed: \(error)")
        }
    }
    
    // Fetch LatestRateModel
    func fetchLatestRate() -> LatestRateModel? {
        let request: NSFetchRequest<LatestRateEntity> = LatestRateEntity.fetchRequest()
        
        do {
            if let entity = try context.fetch(request).first,
               let rates = entity.rates,
               let base = entity.base,
               let date = entity.date {
                let decodedRates = try JSONDecoder().decode([String: Double].self, from: rates)
                print("Fetch successful")
                return LatestRateModel(
                    success: entity.success,
                    timestamp: Int(entity.timestamp),
                    base: base,
                    date: date,
                    rates: decodedRates
                )
            }
        } catch {
            print("Fetch or decode failed: \(error)")
        }
        return nil
    }
    
    // Delete All Cached Rates
    func deleteAllRates() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = LatestRateEntity.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(deleteRequest)
            saveContext()
        } catch {
            print("Failed to delete: \(error)")
        }
    }
}
