//
//  Warehouse.swift
//  isTag
//
//  Created by Domo on 19/07/2019.
//  Copyright © 2019 Domo. All rights reserved.
//

import Foundation

// MARK: - Warehouse
class Warehouse: Codable {
    let name, category, picture: String
    let currentOwner: CurrentOwner
    let warehouseDescription: String
    
    enum CodingKeys: String, CodingKey {
        case name, category, currentOwner, picture
        case warehouseDescription = "description"
    }
    
    init(name: String, picture: String, category: String, currentOwner: CurrentOwner, warehouseDescription: String) {
        self.name = name
        self.picture = picture
        self.category = category
        self.currentOwner = currentOwner
        self.warehouseDescription = warehouseDescription
    }
}

// MARK: - CurrentOwner
class CurrentOwner: Codable {
    let name, email: String
    
    init(name: String, email: String) {
        self.name = name
        self.email = email
    }
}

