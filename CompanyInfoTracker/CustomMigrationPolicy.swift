//
//  CustomMigrationPolicy.swift
//  CompanyInfoTracker
//
//  Created by Chase McElroy on 3/1/18.
//  Copyright © 2018 Chase McElroy. All rights reserved.
//

import CoreData

class CustomMigrationPolicy: NSEntityMigrationPolicy {
    @objc func transformNumEmployees(forNum: NSNumber) -> String {
        if forNum.intValue < 150 {
            return "small"
        } else {
            return "very large"
        }
    }
}
