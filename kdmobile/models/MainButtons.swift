//
//  MainButtons.swift
//  kdmobile
//
//  Created by Admin on 27.06.2022.
//

import Foundation

let mainButtons = [
    "Приемка",
    "Отгрузка",
    "Инвентаризация",
    "Возврат товара",
]

let mainButtonsDeclinationTasks: [String : String] = ["Приемка":"приемку",
                                                      "Отгрузка":"отгрузку",
                                                      "Инвентаризация":"инвентаризацию",
                                                      "Возврат товара":"возврат товара"]

let mainButtonsDeclinationAcceptedTasks: [String : String] = ["Приемка":"приемке",
                                                              "Отгрузка":"отгрузке",
                                                              "Инвентаризация":"инвентаризации",
                                                              "Возврат товара":"возврату товара"]
