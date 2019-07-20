//
//  WarehouseHistoryObject.swift
//  isTag
//
//  Created by Domo on 20/07/2019.
//  Copyright © 2019 Domo. All rights reserved.
//
import Foundation

// MARK: - WarehouseHistoryObjectElement
class WarehouseHistoryObjectElement: Codable {
    let changeDate: String
    let objectName: String
    let owner: Owner?
    
    init(changeDate: String, objectName: String, owner: Owner?) {
        self.changeDate = changeDate
        self.objectName = objectName
        self.owner = owner
    }
}

// MARK: - Owner
class Owner: Codable {
    let name, email: String
    
    init(name: String, email: String) {
        self.name = name
        self.email = email
    }
}

typealias WarehouseHistoryObject = [WarehouseHistoryObjectElement]
