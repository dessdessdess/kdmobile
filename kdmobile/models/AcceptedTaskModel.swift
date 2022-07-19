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

class AcceptedTaskModel: NSObject, NSCoding, Codable, TaskModelProtocol {
           
    let number: String
    let date: String
    let documentType: String
    let guid: String
    let client: String
    let products: [Product]
            
    //for save in Userdefaults
    func encode(with coder: NSCoder) {
        coder.encode(self.number, forKey: "number")
        coder.encode(self.date, forKey: "date")
        coder.encode(self.documentType, forKey: "documentType")
        coder.encode(self.guid, forKey: "guid")
        coder.encode(self.client, forKey: "client")
        coder.encode(self.products, forKey: "products")
    }
    
    //for save in Userdefaults
    required init?(coder: NSCoder) {
        self.number = coder.decodeObject(forKey: "number") as? String ?? ""
        self.date = coder.decodeObject(forKey: "date") as? String ?? ""
        self.documentType = coder.decodeObject(forKey: "documentType") as? String ?? ""
        self.guid = coder.decodeObject(forKey: "guid") as? String ?? ""
        self.client = coder.decodeObject(forKey: "client") as? String ?? ""
        self.products = coder.decodeObject(forKey: "products") as? [Product] ?? []
    }
    
    enum CodingKeys: String, CodingKey {
        case number = "НомерДокумента"
        case date = "ДатаДокумента"
        case documentType = "ВидДокумента"
        case guid = "GUID"
        case client = "Клиент"
        case products = "Товары"
    }
    
//    static func == (lhs: AcceptedTaskModel, rhs: AcceptedTaskModel) -> Bool {
//        lhs.guid == rhs.guid
//    }
           
    static func < (lhs: AcceptedTaskModel, rhs: AcceptedTaskModel) -> Bool {
        lhs.date < rhs.date
    }
    
}

class Product: NSObject, NSCoding, Codable {
    
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
    
    //for save in Userdefaults
    func encode(with coder: NSCoder) {
        coder.encode(self.nomenclature, forKey: "nomenclature")
        coder.encode(self.characteristic, forKey: "characteristic")
        coder.encode(self.count, forKey: "count")
        coder.encode(self.unit, forKey: "unit")
        coder.encode(self.scanCount, forKey: "scanCount")
    }
    
    //for save in Userdefaults
    required init?(coder: NSCoder) {
        self.nomenclature = coder.decodeObject(forKey: "nomenclature") as? String ?? ""
        self.characteristic = coder.decodeObject(forKey: "characteristic") as? String ?? ""
        self.count = coder.decodeInteger(forKey: "count")
        self.unit = coder.decodeObject(forKey: "unit") as? String ?? ""
        self.scanCount = coder.decodeInteger(forKey: "scanCount")
    }
    
}
