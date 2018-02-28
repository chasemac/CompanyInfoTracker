//
//  CompaniesController.swift
//  CompanyInfoTracker
//
//  Created by Chase McElroy on 2/23/18.
//  Copyright © 2018 Chase McElroy. All rights reserved.
//

import UIKit
import CoreData

class CompaniesController: UITableViewController {
    
    var companies = [Company]()
    
    //let's do some tricky updates with coreData
    @objc private func doUpdates() {
        print("doing updates")
        CoreDataManager.shared.persistentContainer.performBackgroundTask { (backgroundContext) in
            
            let request: NSFetchRequest<Company> = Company.fetchRequest()
            do {
                let companies = try backgroundContext.fetch(request)
                companies.forEach({ (company) in
                    print(company.name ?? "")
                    company.name = "C: \(company.name ?? "")"
                })
                
                do {
                    try backgroundContext.save()
                    
                    // try to update UI after a save
                    DispatchQueue.main.async {
                        
                        // reset will forget all of the objects you set before
                        CoreDataManager.shared.persistentContainer.viewContext.reset()
                        
                        // you don't want to refetch everything if you're just ubpating one or two things
                        self.companies = CoreDataManager.shared.fetchCompanies()
                        
                        // can we merge changes onto main view context
                        self.tableView.reloadData()
                    }
                } catch let saveErr {
                    print("failed to save on background: ", saveErr)
                }
                
            } catch let err {
                print("Failed to fetch companies on background: ",err)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.companies = CoreDataManager.shared.fetchCompanies()
        
        navigationItem.leftBarButtonItems = [
        UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(handleReset)),
        UIBarButtonItem(title: "Do Updates", style: .plain, target: self, action: #selector(doUpdates))
        ]
        
        view.backgroundColor = .white
        
        navigationItem.title = "Companies"
        
        tableView.backgroundColor = .darkBlue
        //    tableView.separatorStyle = .none
        tableView.separatorColor = .white
        tableView.tableFooterView = UIView()
        
        tableView.register(CompanyCell.self, forCellReuseIdentifier: "cellId")
        
        setupPlusButtonInNavBar(selector: #selector(handleAddCompany))
    }
    
    @objc private func doWork() {
        print("trying to do work")
        
        CoreDataManager.shared.persistentContainer.performBackgroundTask({ (backgroundContext) in
            (0...5).forEach { (value) in
                print(value)
                let company = Company(context: backgroundContext)
                company.name = String(value)
                
            }
            do {
                try backgroundContext.save()
                DispatchQueue.main.async {
                    self.companies = CoreDataManager.shared.fetchCompanies()
                    self.tableView.reloadData()
                }
            } catch let err {
                print("Failed to save: ", err)
            }
        })
        
        // GCD = Grand Central Dispatch

//        DispatchQueue.global(qos: .background).async {
//            // creating some Compan objects on a background thread
//
//          //  let context = CoreDataManager.shared.persistentContainer.viewContext
//
//        }
    }
    

    
    @objc private func handleReset() {
        
        CoreDataManager.shared.deleteAllCompanies { (err, success) in
            if err != nil {
                print("Crappppp: ",err! as String)
            }

            if success {
                var indexPathsToRemove = [IndexPath]()
                for (index, _) in companies.enumerated() {
                    let indexPath = IndexPath(row: index, section: 0)
                    indexPathsToRemove.append(indexPath)
                }
                companies.removeAll()
                tableView.deleteRows(at: indexPathsToRemove, with: .left)
            }
        }

    }
    
    @objc func handleAddCompany() {
        print("Adding company..")
        let createCompanyController = CreateCompanyController()
        let navController = CustomNavigationController(rootViewController: createCompanyController)
        
        createCompanyController.delegate = self
        
        present(navController, animated: true, completion: nil)
    }
    
    
}

