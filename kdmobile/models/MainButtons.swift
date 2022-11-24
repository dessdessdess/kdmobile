//
//  MainButtons.swift
//  kdmobile
//
//  Created by Admin on 27.06.2022.
//

import Foundation

class MainButtons {
    
    static let mainButtons = [
        "Приемка",
        "Отгрузка",
        "Инвентаризация",
        "Возврат товара"
    ]
    
    static let mainButtonsDeclinationTasks: [String : String] = ["Приемка":"приемку",
                                                          "Отгрузка":"отгрузку",
                                                          "Инвентаризация":"инвентаризацию",
                                                          "Возврат товара":"возврат товара"]
    
    static let mainButtonsDeclinationAcceptedTasks: [String : String] = ["Приемка":"приемке",
                                                                  "Отгрузка":"отгрузке",
                                                                  "Инвентаризация":"инвентаризации",
                                                                  "Возврат товара":"возврату товара"]
}
