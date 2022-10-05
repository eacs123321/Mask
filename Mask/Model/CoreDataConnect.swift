//
//  CoreDataConnect.swift
//  Mask
//
//  Created by 何安竺 on 2022/10/5.
//

import Foundation
import CoreData

class CoreDataConnect{
    static let share = CoreDataConnect(modelName: "Mask")
    let persistenContainer: NSPersistentContainer
    var context : NSManagedObjectContext {return persistenContainer.viewContext}
    init(modelName: String) {
        persistenContainer = NSPersistentContainer(name: modelName)
    }
    
    func load(completion: (()->Void)? = nil) {
        persistenContainer.loadPersistentStores { description, error in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
            completion?()
        }
    }
    
    func save() {
        if context.hasChanges {
            do {
                try context.save()
            }
            catch {
                print("Save error: \(error)")
            }
        }
    }
}
extension CoreDataConnect{
    //MARK: -新增資料
    func insertData(info: PharmacyInfo){
        let pharmacy = PharmaciesTable(context: context)
        pharmacy.id = info.id
        pharmacy.name = info.name
        pharmacy.mask_adult = Int32(info.mask_adult)
        pharmacy.mask_child = Int32(info.mask_child)
        pharmacy.county = info.county
        pharmacy.town = info.town
        save()
    }
    //MARK: - 刪除資料
    func deletData(info : PharmaciesTable){
        context.delete(info)
        save()
    }
    
    func createMaskInfoTableFetchResultController(filter: String? = nil, sorter: String? = nil) -> NSFetchedResultsController<PharmaciesTable> {
        let fetchRequest = NSFetchRequest<PharmaciesTable>(entityName: "PharmaciesTable")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: sorter, ascending: true)]
        
        if let filter = filter {
            let predicate = NSPredicate(format: "town == %@", filter)
            fetchRequest.predicate = predicate
        }
        return NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
    }
}
