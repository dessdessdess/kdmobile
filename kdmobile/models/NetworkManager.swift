//
//  NetworkManager.swift
//  kdmobile
//
//  Created by Admin on 27.07.2022.
//

import Foundation
import UIKit

final class NetworkManager {
    
    private let pathToServer = "http://31.13.133.10/brinex/hs/StoragePointV2"
    private let userGuid = "169424d7-0796-11ea-bbc4-14187764496c"
    private let warehouseGuid = "313dd8f4-b47f-11eb-bbaa-c81f66f5fe1a"
    
    static func configuredNetworkManager() -> NetworkManager {
        let networkManager = NetworkManager()
        return networkManager
    }
    
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
    
    func getAcceptedTasks(completion: @escaping ([AcceptedTaskModel]?)->Void ) {
        
        let params = ["GUIDСклада": warehouseGuid,
                      "GUIDПользователя": userGuid]
        
        guard let request = getRequest(with: params, requestPath: "/Read/SaleDocs") else { return }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    
                    if let data = data {
                        
                        //let jsonResult = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSMutableDictionary
                        
                        let decoder = JSONDecoder()
                        
                        if let acceptedDataTasksFromNetwork = try? decoder.decode(AcceptedTaskCommonModel.self, from: data) {
                                                       
                            DispatchQueue.main.async {
                                completion(acceptedDataTasksFromNetwork.docsArray)
                            }
                            
                        } else {
                            
                            DispatchQueue.main.async {
                                completion(nil)
                            }
                            
                        }
                        
                    }
                    
                } else {
                    
                    print(httpResponse.statusCode)
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                    
                }
            }
            
        }
        
        task.resume()       
        
    }
    
    func getTasks(completion: @escaping ([TaskModel]?)->Void) {
        
        let params = ["GUIDСклада": warehouseGuid,
                      "GUIDПользователя": userGuid]
        guard let request = getRequest(with: params, requestPath: "/Read/Tasks") else { return }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    
                    if let data = data {
                        
                        let decoder = JSONDecoder()
                        
                        if let dataTasksFromNetwork = try? decoder.decode([TaskModel].self, from: data) {
                            
                            DispatchQueue.main.async {
                                
                                completion(dataTasksFromNetwork)
                                                            
                            }
                            
                        } else {
                            completion(nil)
                            
                        }
                        
                    }
                                        
                } else {
                    
                    print(httpResponse.statusCode)
                    completion(nil)
                    
                }
            }
        }
               
        task.resume()
        
    }
    
    func acceptTasks(selectedTasksToTransfer:[[String:String]], completion: @escaping ()->Void) {
        
        let params: [String:Any] = ["GUIDПользователя":userGuid,
                                    "МассивЗаданий":selectedTasksToTransfer]
        
        
        guard let request = getRequest(with: params, requestPath: "/Write/AcceptTasks") else { return }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                                           
                        DispatchQueue.main.async {
                            
                            completion()
                            
                        }
                                        
                } else {
                    
                    print(httpResponse.statusCode)
                    completion()
                    
                }
            }
        }
        
        task.resume()
        
    }
    
    func auth(with base64LoginString: String, completion: @escaping (Int) -> Void) {
        
        guard let url = URL(string: "\(pathToServer)/Test") else { return }
                
        var request = URLRequest(url: url,timeoutInterval: 30)
        request.addValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")

        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let httpResponse = response as? HTTPURLResponse {
                DispatchQueue.main.async {
                    completion(httpResponse.statusCode)
                }
            }
                                    
        }
        
        task.resume()
        
    }

}

