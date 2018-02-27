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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.companies = CoreDataManager.shared.fetchCompanies()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(handleReset))
        
        view.backgroundColor = .white
        
        navigationItem.title = "Companies"
        
        tableView.backgroundColor = .darkBlue
        //    tableView.separatorStyle = .none
        tableView.separatorColor = .white
        tableView.tableFooterView = UIView()
        
        tableView.register(CompanyCell.self, forCellReuseIdentifier: "cellId")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plus").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleAddCompany))
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

