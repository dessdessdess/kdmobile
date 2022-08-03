//
//  NetworkManager.swift
//  kdmobile
//
//  Created by Admin on 27.07.2022.
//

import Foundation
import UIKit

final class NetworkManager {
    
    private let pathToServer = "http://192.168.11.30/Brinex_abzanov.r/hs/StoragePointV2"
    private let userGuid = "eaf3c420-11c1-11e6-814f-c81f66f5f5a5"
    private let warehouseGuid = "313dd8f4-b47f-11eb-bbaa-c81f66f5fe1a"
        
    private func getRequest(with params: [String:Any], requestPath: String) -> URLRequest? {
        
        let userDefaults = UserDefaults.standard
        
        guard let userName = userDefaults.string(forKey: UserDefaultsKeys.userName), let password = userDefaults.string(forKey: UserDefaultsKeys.password) else { return nil }
        let loginString = "\(userName):\(password)"
        guard let loginData = loginString.data(using: String.Encoding.utf8) else { return nil }
    
        let base64LoginString = loginData.base64EncodedString()
        
        guard let url = URL(string: "\(pathToServer)\(requestPath)") else { return nil }
                
        var request = URLRequest(url: url,timeoutInterval: 30)
        request.addValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
       
        guard let jsonData = try? JSONSerialization.data(withJSONObject: params, options: .prettyPrinted) else { return nil }
                
        request.httpMethod = "POST"
        request.httpBody = jsonData
        
        return request
        
    }
        
    func getAcceptedTasks(dataManager: DataManager, completion: @escaping ()->Void ) {
        
        let params = ["GUIDСклада": warehouseGuid,
                      "GUIDПользователя": userGuid]
        
        guard let request = getRequest(with: params, requestPath: "/Read/SaleDocs") else { return }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    
                    if let data = data {
                        
                        //let jsonResult = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSMutableDictionary
                                                                    
                        let decoder = JSONDecoder()
                                                
                        guard let acceptedDataTasksFromNetwork = try? decoder.decode(AcceptedTaskCommonModel.self, from: data) else { return }
                        
                        for item in acceptedDataTasksFromNetwork.docsArray {
                            if !dataManager.containsAcceptedTask(guid: item.guid) {
                                dataManager.createAcceptedTask(acceptedTask: item)
                            }
                        }
                                                
                        DispatchQueue.main.async {
                            completion()
                       }
                        
                    }
                                        
                } else {
                    
                    print(httpResponse.statusCode)
                    
                }
            }
        }
               
        task.resume()
        
    }
       
}
