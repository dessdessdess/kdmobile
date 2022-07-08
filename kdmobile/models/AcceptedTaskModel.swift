//
//  AcceptedTaskModel.swift
//  kdmobile
//
//  Created by Admin on 07.07.2022.
//

import Foundation

struct AcceptedTaskCommonModel: Codable {
    let docsArray: [AcceptedTaskModel]
    
    enum CodingKeys: String, CodingKey {
        case docsArray = "МассивДокументов"
    }
    
}

class AcceptedTaskModel: Codable, Comparable, TaskModelProtocol {
    static func == (lhs: AcceptedTaskModel, rhs: AcceptedTaskModel) -> Bool {
        lhs.guid == rhs.guid
    }
           
    static func < (lhs: AcceptedTaskModel, rhs: AcceptedTaskModel) -> Bool {
        lhs.date < rhs.date
    }
    
    let number: String
    let date: String
    let documentType: String
    let guid: String
    let client: String
    let product: [Product]
        
    enum CodingKeys: String, CodingKey {
        case number = "НомерДокумента"
        case date = "ДатаДокумента"
        case documentType = "ВидДокумента"
        case guid = "GUID"
        case client = "Клиент"
        case product = "Товары"
    }
    
}

struct Product: Codable {
    
    let nomenclature: String
    let characteristic: String
    let count: Int
    let unit: String
    
    enum CodingKeys: String, CodingKey {
        case nomenclature = "Номенклатура"
        case characteristic = "Характеристика"
        case count = "Количество"
        case unit = "ЕдиницаИзмерения"
    }
    
}
