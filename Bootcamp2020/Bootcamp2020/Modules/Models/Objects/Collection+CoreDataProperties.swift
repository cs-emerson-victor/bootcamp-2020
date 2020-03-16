//
//  Collection+CoreDataProperties.swift
//  
//
//  Created by jacqueline alves barbosa on 13/03/20.
//
//

import Foundation
import CoreData

extension Collection {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Collection> {
        return NSFetchRequest<Collection>(entityName: "Collection")
    }

    @NSManaged public var name: String
    @NSManaged public var id: String
    @NSManaged public var releaseDate: Date
    @NSManaged public var cards: NSSet

}

// MARK: Generated accessors for cards
extension Collection {

    @objc(addCardsObject:)
    @NSManaged public func addToCards(_ value: Card)

    @objc(removeCardsObject:)
    @NSManaged public func removeFromCards(_ value: Card)

    @objc(addCards:)
    @NSManaged public func addToCards(_ values: NSSet)

    @objc(removeCards:)
    @NSManaged public func removeFromCards(_ values: NSSet)

}
