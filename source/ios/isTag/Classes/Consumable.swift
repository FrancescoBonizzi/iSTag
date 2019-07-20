//
//  Consumable.swift
//  isTag
//
//  Created by Domo on 20/07/2019.
//  Copyright © 2019 Domo. All rights reserved.
//

// MARK: - Consumables
class Consumable: Codable {
    let name, qrCode, status, category: String
    let consumablesDescription, image: String
    let isMissing: Bool
    
    enum CodingKeys: String, CodingKey {
        case name, qrCode, status, category
        case consumablesDescription = "description"
        case image, isMissing
    }
    
    init(name: String, qrCode: String, status: String, category: String, consumablesDescription: String, image: String, isMissing: Bool) {
        self.name = name
        self.qrCode = qrCode
        self.status = status
        self.category = category
        self.consumablesDescription = consumablesDescription
        self.image = image
        self.isMissing = isMissing
    }
}
