//
//  DataManager.swift
//  kdmobile
//
//  Created by Admin on 27.07.2022.
//

import Foundation
import CoreData

var persistentContainer: NSPersistentContainer = {
    
    let container = NSPersistentContainer(name: "kdmobile")
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
        if let error = error as NSError? {
            
            fatalError("Unresolved error \(error), \(error.userInfo)")
        }
    })
    return container
}()

class DataManager: NSObject {
    
    private let acceptedTaskFetchRequest: NSFetchRequest<AcceptedTask> = AcceptedTask.fetchRequest()
    private let acceptedTasksFetchResultController: NSFetchedResultsController<AcceptedTask>
    
    private let productFetchRequest: NSFetchRequest<ProductS> = ProductS.fetchRequest()
    private let productFetchResultController: NSFetchedResultsController<ProductS>
        
    override init() {
            
        let sortDescriptor = NSSortDescriptor(key: "number", ascending: true)
        acceptedTaskFetchRequest.sortDescriptors = [sortDescriptor]
                
        acceptedTasksFetchResultController = NSFetchedResultsController(fetchRequest: acceptedTaskFetchRequest, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
        let productSortDescriptor = NSSortDescriptor(key: "nomenclature", ascending: true)
        productFetchRequest.sortDescriptors = [productSortDescriptor]
                
        productFetchResultController = NSFetchedResultsController(fetchRequest: productFetchRequest, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
        super.init()
        
        try? acceptedTasksFetchResultController.performFetch()
        try? productFetchResultController.performFetch()
               
        acceptedTasksFetchResultController.delegate = self
        productFetchResultController.delegate = self
        
    }
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
            
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func getAcceptedTasksCount(section: Int) -> Int {
        return acceptedTasksFetchResultController.sections?[section].numberOfObjects ?? 0
    }
    
    func getAcceptedTask(indexPath: IndexPath) -> AcceptedTask {
       return acceptedTasksFetchResultController.object(at: indexPath)
    }
    
    func containsAcceptedTask(guid: String) -> Bool {
        
        acceptedTaskFetchRequest.predicate = NSPredicate(format: "guid == %@", guid)
        if let acceptedTasks = try? persistentContainer.viewContext.fetch(acceptedTaskFetchRequest) {
            return !acceptedTasks.isEmpty
        }
        
        return false
    }
    
    func createAcceptedTask(acceptedTask: AcceptedTaskModel) {
        
        let newAcceptedTask = AcceptedTask(context: persistentContainer.viewContext)
        newAcceptedTask.client = acceptedTask.client
        newAcceptedTask.guid = acceptedTask.guid
        newAcceptedTask.number = acceptedTask.number
        newAcceptedTask.date = acceptedTask.date
        newAcceptedTask.documentType = acceptedTask.documentType
        
        for product in acceptedTask.products {
            
            let newProduct = ProductS(context: persistentContainer.viewContext)
            newProduct.nomenclature = product.nomenclature
            newProduct.characteristic = product.characteristic
            newProduct.count = Int16(product.count)
            newProduct.unit = product.unit
            newProduct.scanCount = 0
            
            newAcceptedTask.addToProducts(newProduct)
            
        }
        
        saveContext()
        
    }
    
    func deleteAcceptedTask(indexPath: IndexPath) {
        let acceptedTask = acceptedTasksFetchResultController.object(at: indexPath)
        persistentContainer.viewContext.delete(acceptedTask)
        saveContext()
    }
    
    func getProducts(acceptedTask: AcceptedTask) -> [ProductS] {
       
        productFetchRequest.predicate = NSPredicate(format: "acceptedTask == %@", acceptedTask)
        if let products = try? persistentContainer.viewContext.fetch(productFetchRequest) {
            return products
        }
        
        return []
    }
        
}


extension DataManager: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            return
        case .delete:
            return
        case .move:
            return
        case .update:
            return
        @unknown default:
            return
        }
        
    }
    
}
