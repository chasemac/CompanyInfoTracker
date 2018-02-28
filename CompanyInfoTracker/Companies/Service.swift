//
//  Service.swift
//  CompanyInfoTracker
//
//  Created by Chase McElroy on 2/28/18.
//  Copyright © 2018 Chase McElroy. All rights reserved.
//

import Foundation

struct Service {
    
    static let shared = Service()
    
    let urlString = "https://api.letsbuildthatapp.com/intermediate_training/companies"
    
    func downloadCompaniesFromServer() {
        print("attempting to download companies")
        
        guard let url = URL(string: urlString) else {return}
        URLSession.shared.dataTask(with: url) { (data, resp, err) in
            print("Finished downloading")
            
            if let err = err {
                print("failed to download companies", err)
                return
            }
            guard let data = data else {return}
            
            let jsonDecoder = JSONDecoder()
            
            do {
                let jsonCompanies = try jsonDecoder.decode([JSONCompany].self, from: data)
                jsonCompanies.forEach({ (jsonCompany) in
                    print(jsonCompany.name)
                    jsonCompany.employees?.forEach({ (jsonEmployee) in
                        print(" \(jsonEmployee.name)")
                    })
                })
            } catch let jsonDecodeErr {
                print("failed to decode:" ,jsonDecodeErr)
            }
            
//            let string = String(data: data, encoding: .utf8)
          
            
        }.resume() // please do not forget to make this call
    }
}

struct JSONCompany: Decodable {
    let name: String
    let founded: String
    var employees: [JSONEmployee]?
}

struct JSONEmployee: Decodable {
    let name: String
    let birthday: String
    let type: String
}