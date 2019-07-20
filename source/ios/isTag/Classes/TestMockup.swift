//
//  TestMockup.swift
//  isTag
//
//  Created by Domo on 19/07/2019.
//  Copyright © 2019 Domo. All rights reserved.
//

import Foundation

class TestMockup: RequestProtocol {
    
    func isAlive(token: String) {
        print("someTypeMethod from Test")
    }
    
    func genericObjectApi(token: String, qRCode: String, completation: @escaping (GenericObjectApiResponse?) -> ()) {
        print("GenericObjectApi from Test")
    }
    
    func warehouseGetData(token: String, qRCode: String, completation: @escaping (Warehouse?) -> ())  {
        print("WarehouseGetData from Test")
    }

    func warehouseGetHistoryByOBject(token: String, qRCode: String, completation: @escaping (WarehouseHistoryObject?) -> ()) {
        print("warehouseGetHistoryByOBject from Test")
    }
    
    func warehouseGetHistoryByUser(token: String, email: String, completation: @escaping (WarehouseHistoryObject?) -> ()) {
        print("warehouseGetHistoryByUser from Test")
    }
    
    func warehouseGive(token: String, qRCode: String, who: String, completation: @escaping (String) -> ()) {
        print("WarehouseGive from Test")
    }
    
    func consumablesGetData(token: String, qRCode: String, completation: @escaping (Consumable?) -> ()) {
        print("ConsumablesGetData from Test")
    }
    
    func consumablesGetMissingNotMissing(token: String, qRCode: String, completation: @escaping (String?) -> ()) {
        print("ConsumablesGetMissingNotMissing from Test")
    }
    
}
