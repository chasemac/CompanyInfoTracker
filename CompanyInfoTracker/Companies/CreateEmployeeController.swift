//
//  CreateEmployeeController.swift
//  CompanyInfoTracker
//
//  Created by Chase McElroy on 2/27/18.
//  Copyright © 2018 Chase McElroy. All rights reserved.
//

import UIKit

class CreateEmployeeController: UIViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Create Employee"
        
        setupCancelButton()
        view.backgroundColor = .darkBlue
    }
}
