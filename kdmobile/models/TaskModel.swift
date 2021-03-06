//
//  TaskModel.swift
//  kdmobile
//
//  Created by Admin on 29.06.2022.
//

import Foundation

class TaskModel: Codable, Comparable, TaskModelProtocol {
    static func == (lhs: TaskModel, rhs: TaskModel) -> Bool {
        lhs.guid == rhs.guid
    }
    
    static func < (lhs: TaskModel, rhs: TaskModel) -> Bool {
        lhs.date < rhs.date
    }
    
    let number: String
    let date: String
    let documentType: String
    let guid: String
    let client: String
        
    enum CodingKeys: String, CodingKey {
        case number = "Номер"
        case date = "Дата"
        case documentType = "ВидДокумента"
        case guid = "GUID"
        case client = "Клиент"
    }
    
    static func getFormatDate(dateToFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let date = dateFormatter.date(from: dateToFormat)!
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let stringDate = dateFormatter.string(from: date)
        return stringDate
    }
    
}
