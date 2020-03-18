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
    private(set) var isFavorite: Bool = false
    let types: List<CardType> = List<CardType>()
    
    convenience init(id: String,
                     name: String,
                     imageURL: String? = nil,
                     imageData: Data? = nil,
                     isFavorite: Bool = false,
                     types: [CardType] = []) {
        self.init()
        self.id = id
        self.name = name
        self.imageURL = imageURL
        self.imageData = imageData
        self.isFavorite = isFavorite
        self.types.append(objectsIn: types)
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override static func ignoredProperties() -> [String] {
        return ["isFavorite"]
    }
    
    @discardableResult
    func toggleFavorite() -> Bool {
        isFavorite = !isFavorite
        return isFavorite
    }
}

extension Card: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case imageURL = "imageUrl"
    }
}
