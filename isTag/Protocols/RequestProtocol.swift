//
//  RequestProtocol.swift
//  isTag
//
//  Created by Domo on 19/07/2019.
//  Copyright © 2019 Domo. All rights reserved.
//

import Foundation

protocol RequestProtocol {
    
    func isAlive(token: String)
    
    func genericObjectApi(token: String, qRCode: String, completation: @escaping (GenericObjectApiResponse?) -> ())
    
    func warehouseGetData(token: String, qRCode: String, completation: @escaping (Warehouse?) -> ()) 

    func warehouseGetHistory(token: String, qRCode: String)
    
    func warehouseGive(token: String, qRCode: String, who: String, completation: @escaping (Bool) -> ())
    
    func consumablesGetData(token: String, qRCode: String, completation: @escaping (Consumable?) -> ())
    
    func consumablesGetMissingNotMissing(token: String, qRCode: String, completation: @escaping (String?) -> ())
    
}
