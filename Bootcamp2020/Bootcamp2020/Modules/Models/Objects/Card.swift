//
//  Card.swift
//  Bootcamp2020
//
//  Created by emerson.victor.f.luz on 17/03/20.
//  Copyright © 2020 Team2. All rights reserved.
//

import RealmSwift

final class Card: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var imageURL: String?
    @objc dynamic var imageData: Data?
    let types: List<CardType> = List<CardType>()
    
    convenience init(id: String,
                     name: String,
                     imageURL: String? = nil,
                     imageData: Data? = nil,
                     categories: [CardType] = []) {
        self.init()
        self.id = id
        self.name = name
        self.imageURL = imageURL
        self.imageData = imageData
        self.types.append(objectsIn: categories)
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

extension Card: Codable {
    
}
