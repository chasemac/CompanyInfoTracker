//
//  CompaniesController.swift
//  CompanyInfoTracker
//
//  Created by Chase McElroy on 2/23/18.
//  Copyright © 2018 Chase McElroy. All rights reserved.
//

import UIKit
import CoreData

class CompaniesController: UITableViewController, CreateCompanyControllerDelagate {
    
    func didEditCompany(company: Company) {
        // update my tableview
        let row = companies.index(of: company)
        let relaodIndexPath = IndexPath(row: row!, section: 0)
        tableView.reloadRows(at: [relaodIndexPath], with: .middle)
    }
    

    func didAddCompany(company: Company) {
        //1 Modify array
        companies.append(company)
        
        //insert a new index path into tableview
        let newIndexPath = IndexPath(row: companies.count - 1, section: 0)
        tableView.insertRows(at: [newIndexPath], with: .automatic)
    }

    var companies = [Company]()
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (_, indexPath) in
            let company = self.companies[indexPath.row]
            print("Attempting to delete company: ",company.name ?? "")
            
            //remove the company from our tableview
            self.companies.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            
            
            //delete company from CoreData
            let context = CoreDataManager.shared.persistentContainer.viewContext
            
            context.delete(company)
            do {
                try context.save()
            } catch let saveErr {
                print("failed to delete company :",saveErr)
            }
            
        }
        deleteAction.backgroundColor = .lightRed
        
        let editAction = UITableViewRowAction(style: .normal, title: "Edit", handler: editHandlerFunction)
        editAction.backgroundColor = .darkBlue
        
        return [deleteAction, editAction]
    }
    
//    func didEditCompany(company: Company) {
//        
//    }
    
    private func editHandlerFunction(action: UITableViewRowAction, indexPath: IndexPath) {
        print("Editing company in separate func")
        let editCompanyController = CreateCompanyController()
        editCompanyController.delegate = self
        editCompanyController.company = companies[indexPath.row]
        let navController = CustomNavigationController(rootViewController: editCompanyController)
        present(navController, animated: true, completion: nil)
    }
    
    private func fetchCompanies() {
        // initialization of our Core Data stack
        
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Company>(entityName: "Company")
        do {
            let companies = try context.fetch(fetchRequest)
            companies.forEach({ (company) in
                print(company.name ?? "")
            })
            
            self.companies = companies
            self.tableView.reloadData()
        } catch let fetchErr {
            print("Failed to fetch companies : ",fetchErr)
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchCompanies()
        
//        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "TEST", style: .plain, target: self, action: #selector(addCompany))
        view.backgroundColor = .white
        
        navigationItem.title = "Companies"
        
        tableView.backgroundColor = .darkBlue
    //    tableView.separatorStyle = .none
        tableView.separatorColor = .white
        tableView.tableFooterView = UIView()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plus").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleAddCompany))
    }
    
    @objc func handleAddCompany() {
        print("Adding company..")
        let createCompanyController = CreateCompanyController()
 //       createCompanyController.view.backgroundColor = .green
        
        let navController = CustomNavigationController(rootViewController: createCompanyController)
        
        createCompanyController.delegate = self
        
        present(navController, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .lightBlue
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        
        cell.backgroundColor = .tealColor
        
        let company = companies[indexPath.row]
        
        if let name = company.name, let founded = company.founded {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, YYYY"
            
            let foundedDateString = dateFormatter.string(from: founded)
  //          let locale = Locale(identifier: "EN")
            
            let dateString =  "\(name) - Founded: \(foundedDateString)"
            cell.textLabel?.text = dateString
        } else {
            cell.textLabel?.text = company.name
        }
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companies.count
    }

}

