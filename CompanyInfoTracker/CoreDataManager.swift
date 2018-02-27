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
    
    func fetchCompanies() -> [Company] {
        let context = persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Company>(entityName: "Company")
        do {
            let companies = try context.fetch(fetchRequest)
            return companies
        } catch let fetchErr {
            print("Failed to fetch companies : ",fetchErr)
            return []
        }
    }
 
    
    func deleteAllCompanies(completion: (_ error: String?, _ success: Bool) -> ()){
        let context = persistentContainer.viewContext
        
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: Company.fetchRequest())
        do {
            try context.execute(batchDeleteRequest)
            completion(nil, true)
            
        } catch let delErr {
            print("failed to delete objects from Core Data: ", delErr)
            let err = delErr.localizedDescription
            completion(err, false)
        }
    }
    
    func createEmployee(employeeName: String) -> (Employee? ,Error?) {
        let context = persistentContainer.viewContext
        
        //create employee
        let employee = NSEntityDescription.insertNewObject(forEntityName: "Employee", into: context) as! Employee
        employee.setValue(employeeName, forKey: "name")
        do {
            try context.save()
            return (employee, nil)
        } catch let err {
            print("failed to create employee: ",err)
            return (nil, err)
        }
    }
}
