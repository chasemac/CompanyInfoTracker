//
//  CompaniesController+CreateCompany.swift
//  CompanyInfoTracker
//
//  Created by Chase McElroy on 2/27/18.
//  Copyright © 2018 Chase McElroy. All rights reserved.
//

import UIKit

extension CompaniesController: CreateCompanyControllerDelagate {
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
}
