//
//  Requests.swift
//  isTag
//
//  Created by Domo on 19/07/2019.
//  Copyright © 2019 Domo. All rights reserved.
//

import Foundation

class Requests: RequestProtocol {
    
    func isAlive(token: String) {

        if let url = URL(string: Constants.azureEndpoint) {
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "GET"
            //request.httpBody = jsonData
            urlRequest.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")
            
            URLSession.shared.dataTask(with: urlRequest) { (data, response, errro) in
                if let data = data {
                    if let jsonString = String(data: data, encoding: .utf8) {
                        print(jsonString)
                    }
                }
            }.resume()

        }
    }
    
    func genericObjectApi(token: String, qRCode: String, completation: @escaping (GenericObjectApiResponse?) -> ()) {
        
        if let url = URL(string: Constants.azureEndpoint + Constants.genericObjectApiEndpoint + qRCode ) {
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "GET"
            //request.httpBody = jsonData
            urlRequest.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")
            
            URLSession.shared.dataTask(with: urlRequest) { (data, response, errro) in
                if let data = data {
                    
                    if let jsonString = String(data: data, encoding: .utf8) {
                        let type = GenericObjectApiResponse(rawValue: jsonString)
                        
                        completation(type)
                        
                        //print(jsonString)
                    }
                }
                }.resume()
            
        }
        
    }
    
    func warehouseGetData(token: String, qRCode: String, completation: @escaping (Warehouse?) -> ()) {
 
        if let url = URL(string: Constants.azureEndpoint + Constants.getWarhouseData + qRCode ) {
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "GET"
            //request.httpBody = jsonData
            urlRequest.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")
            
            URLSession.shared.dataTask(with: urlRequest) { (data, response, errro) in
                
                if let data = data {
                    
                    do {
                        let warhouseResult = try JSONDecoder().decode(Warehouse.self, from: data)
                        
                        completation(warhouseResult)
                        
                    } catch {
                        print(error)
                    }
                    
                    /*
                    if let jsonString = String(data: data, encoding: .utf8) {
                        print(jsonString)
                    }*/
                }
                }.resume()
            
        }

    }
    
    func warehouseGetHistory(token: String, qRCode: String) {
        
        if let url = URL(string: Constants.azureEndpoint + Constants.getWarhouseHistory + qRCode ) {
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "GET"
            //request.httpBody = jsonData
            urlRequest.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")
            
            URLSession.shared.dataTask(with: urlRequest) { (data, response, errro) in
                if let data = data {
                    if let jsonString = String(data: data, encoding: .utf8) {
                        print(jsonString)
                    }
                }
            }.resume()
            
        }
        
    }
    
    func warehouseGive(token: String, qRCode: String, who: String, completation: @escaping (Bool) -> ()) {
        if let url = URL(string: Constants.azureEndpoint + Constants.giveWarehouse) {
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "POST"
            
            // prepare json data
            let json: [String: Any] = ["qrcode": qRCode,
                                       "who": "d.nicoli@isolutions.it"]
            let jsonData = try? JSONSerialization.data(withJSONObject: json)
            urlRequest.httpBody = jsonData
            urlRequest.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")
            urlRequest.setValue( "application/json", forHTTPHeaderField: "Content-Type")
            
            URLSession.shared.dataTask(with: urlRequest) { (data, response, errro) in
                if let data = data {
                    if let jsonString = String(data: data, encoding: .utf8) {
                        
                        if jsonString == "true" {
                            completation(true)
                        } else {
                            completation(false)
                        }
                        
                        print(jsonString)
                    }
                }
                }.resume()
            
        }
    }
    
    func consumablesGetData(token: String, qRCode: String, completation: @escaping (Consumable?) -> ()) {
        if let url = URL(string: Constants.azureEndpoint + Constants.getConsumableData + qRCode ) {
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "GET"
            //request.httpBody = jsonData
            urlRequest.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")
            
            URLSession.shared.dataTask(with: urlRequest) { (data, response, errro) in
                
                if let data = data {
                    
                    do {
                        let consumableResult = try JSONDecoder().decode(Consumable.self, from: data)
                        
                        completation(consumableResult)
                        
                    } catch {
                        print(error)
                    }
                    
                    /*
                     if let jsonString = String(data: data, encoding: .utf8) {
                     print(jsonString)
                     }*/
                }
                }.resume()
            
        }
    }
    
    func consumablesGetMissingNotMissing(token: String, qRCode: String, completation: @escaping (String?) -> ()) {
        if let url = URL(string: Constants.azureEndpoint + Constants.getConsumableMissingNotMissing + qRCode ) {
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "GET"
            //request.httpBody = jsonData
            urlRequest.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")
        
            URLSession.shared.dataTask(with: urlRequest) { (data, response, errro) in
                if let data = data {
                    if let jsonString = String(data: data, encoding: .utf8) {                        
                        completation(jsonString)
                    }
                }
            }.resume()

        }
            
    }
    
}
