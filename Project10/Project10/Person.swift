//
//  Person.swift
//  Project10
//
//  Created by Administrator on 5/1/18.
//  Copyright © 2018 SmartApps. All rights reserved.
//

import UIKit

class Person: NSObject, Codable {
    
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
    
    

}
