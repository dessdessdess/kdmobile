//
//  AcceptedTaskModel.swift
//  kdmobile
//
//  Created by Admin on 07.07.2022.
//

import Foundation

class AcceptedTaskCommonModel: Codable {
    let docsArray: [AcceptedTaskModel]
    
    enum CodingKeys: String, CodingKey {
        case docsArray = "МассивДокументов"
    }
    
}

class AcceptedTaskModel: Codable {
           
    let number: String
    let date: String
    let documentType: String
    let guid: String
    let client: String
    let products: [Product]
            
    enum CodingKeys: String, CodingKey {
        case number = "НомерДокумента"
        case date = "ДатаДокумента"
        case documentType = "ВидДокумента"
        case guid = "GUID"
        case client = "Клиент"
        case products = "Товары"
    }
   
}

class Product: Codable {
    
    let nomenclature: String
    let characteristic: String
    let count: Int
    let unit: String
    var scanCount: Int = 0
    
    enum CodingKeys: String, CodingKey {
        case nomenclature = "Номенклатура"
        case characteristic = "Характеристика"
        case count = "Количество"
        case unit = "ЕдиницаИзмерения"
    }
    
}
