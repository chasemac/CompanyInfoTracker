//
//  CoreDataManager.swift
//  CompanyInfoTracker
//
//  Created by Chase McElroy on 2/26/18.
//  Copyright © 2018 Chase McElroy. All rights reserved.
//

import CoreData

struct CoreDataManager {
    
    static let shared =  CoreDataManager() // will live forever as long as your application is still alive, it's properties will too
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "IntermediateTrainingModels")
        container.loadPersistentStores { (storeDescription, err) in
            if let err = err {
                fatalError("loading of store failed: \(err)")
            }
        }
        return container
    }()
}
