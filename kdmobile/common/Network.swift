//
//  Network.swift
//  kdmobile
//
//  Created by Admin on 29.06.2022.
//

import Foundation

class Network {

    private let userDefaults = UserDefaults.standard
    private let paths = ["ПриемкаTasks":"/Read/BuyDocTasks",
                         "ПриемкаAcceptedTasks":"/Read/BuyDocs",
                         "ОтгрузкаTasks":"/Read/Tasks",
                         "ОтгрузкаAcceptedTasks":"/Read/SaleDocs",
                         "ИнвентаризацияTasks":"/Read/InventoryTasks",
                         "ИнвентаризацияAcceptedTasks":"/Read/InventoryDocs",
                         "Возврат товараTasks":"/Read/FixSaleTasks",
                         "Возврат товараAcceptedTasks":"/Read/FixSaleDoc",
                         "ОтгрузкаWriteAcceptedTasks":"/Write/AcceptTasks",
                         "Возврат товараWriteAcceptedTasks":"/Write/AcceptFixSaleTasks",
                         "ИнвентаризацияWriteAcceptedTasks":"/Write/AcceptInventoryTasks"]
    
    func getRequest(with params: [String:Any], section: String, type: String) -> URLRequest? {
        
        guard let userName = userDefaults.string(forKey: UserDefaultsKeys.userName), let password = userDefaults.string(forKey: UserDefaultsKeys.password) else { return nil }
        let loginString = "\(userName):\(password)"
        guard let loginData = loginString.data(using: String.Encoding.utf8) else { return nil }
    
        let base64LoginString = loginData.base64EncodedString()
        
        guard let path = paths["\(section)\(type)"] else { return nil }
        guard let url = URL(string: "http://192.168.11.30/Brinex_abzanov.r/hs/StoragePointV2\(path)") else { return nil }
                
        var request = URLRequest(url: url,timeoutInterval: 30)
        request.addValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
                
        //let encoder = JSONEncoder()
        guard let jsonData = try? JSONSerialization.data(withJSONObject: params, options: .prettyPrinted) else { return nil }
                
        request.httpMethod = "POST"
        request.httpBody = jsonData
        
        return request
        
    }

}
