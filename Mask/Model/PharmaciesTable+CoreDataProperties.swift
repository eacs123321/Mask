//
//  PharmaciesTable+CoreDataProperties.swift
//  Mask
//
//  Created by 何安竺 on 2022/10/5.
//
//

import Foundation
import CoreData


extension PharmaciesTable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PharmaciesTable> {
        return NSFetchRequest<PharmaciesTable>(entityName: "PharmaciesTable")
    }

    @NSManaged public var county: String?
    @NSManaged public var id: String?
    @NSManaged public var mask_adult: Int32
    @NSManaged public var mask_child: Int32
    @NSManaged public var name: String?
    @NSManaged public var town: String?

}

extension PharmaciesTable : Identifiable {

}
