//
//  ProductS+CoreDataProperties.swift
//  kdmobile
//
//  Created by Admin on 28.07.2022.
//
//

import Foundation
import CoreData


extension ProductS {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProductS> {
        return NSFetchRequest<ProductS>(entityName: "ProductS")
    }

    @NSManaged public var characteristic: String?
    @NSManaged public var count: Int16
    @NSManaged public var nomenclature: String?
    @NSManaged public var scanCount: Int16
    @NSManaged public var unit: String?
    @NSManaged public var acceptedTask: AcceptedTask?

}

extension ProductS : Identifiable {

}
