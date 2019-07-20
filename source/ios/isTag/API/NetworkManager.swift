//
//  NetworkManager.swift
//  isTag
//
//  Created by Domo on 19/07/2019.
//  Copyright © 2019 Domo. All rights reserved.
//

import Foundation

class NetworkManager {
    
    let shared : RequestProtocol
    
    init(shared: RequestProtocol) {
        self.shared = shared
    }
    
}
