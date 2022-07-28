//
//  AcceptedTask+CoreDataProperties.swift
//  kdmobile
//
//  Created by Admin on 28.07.2022.
//
//

import Foundation
import CoreData


extension AcceptedTask: TaskModelProtocol {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AcceptedTask> {
        return NSFetchRequest<AcceptedTask>(entityName: "AcceptedTask")
    }

    @NSManaged public var client: String
    @NSManaged public var date: String
    @NSManaged public var documentType: String
    @NSManaged public var guid: String
    @NSManaged public var number: String
    @NSManaged public var products: NSSet?

}

// MARK: Generated accessors for products
extension AcceptedTask {

    @objc(addProductsObject:)
    @NSManaged public func addToProducts(_ value: ProductS)

    @objc(removeProductsObject:)
    @NSManaged public func removeFromProducts(_ value: ProductS)

    @objc(addProducts:)
    @NSManaged public func addToProducts(_ values: NSSet)

    @objc(removeProducts:)
    @NSManaged public func removeFromProducts(_ values: NSSet)

}

extension AcceptedTask : Identifiable {

}
