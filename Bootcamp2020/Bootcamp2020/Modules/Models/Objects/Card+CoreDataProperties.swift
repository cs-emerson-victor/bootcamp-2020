//
//  Card+CoreDataProperties.swift
//  
//
//  Created by jacqueline alves barbosa on 13/03/20.
//
//

import Foundation
import CoreData

extension Card {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Card> {
        return NSFetchRequest<Card>(entityName: "Card")
    }

    @NSManaged public var id: String
    @NSManaged public var imageURL: String?
    @NSManaged public var imageData: Data?
    @NSManaged public var name: String
    @NSManaged public var categories: NSSet
    @NSManaged public var collection: Collection

}

extension Card {
    convenience init(_ dto: CardDTO) {
        self.init()
        self.id = dto.id
        self.imageURL = dto.imageURL
        self.name = dto.name
    }
}

// MARK: Generated accessors for categories
extension Card {

    @objc(addCategoriesObject:)
    @NSManaged public func addToCategories(_ value: Category)

    @objc(removeCategoriesObject:)
    @NSManaged public func removeFromCategories(_ value: Category)

    @objc(addCategories:)
    @NSManaged public func addToCategories(_ values: NSSet)

    @objc(removeCategories:)
    @NSManaged public func removeFromCategories(_ values: NSSet)

}
