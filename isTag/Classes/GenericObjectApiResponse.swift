//
//  GenericObjectApiResponse.swift
//  isTag
//
//  Created by Domo on 19/07/2019.
//  Copyright © 2019 Domo. All rights reserved.
//

import Foundation

enum GenericObjectApiResponse: String {
    case Consumable
    case Warehouse
    case Static
    
    var description: String {
        return self.rawValue
    }
    
}
