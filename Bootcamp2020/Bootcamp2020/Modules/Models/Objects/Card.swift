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
    @objc dynamic var cardSetID: String = ""
    var isFavorite: Bool = false
    let types: List<String> = List<String>()

    convenience init(id: String,
                     name: String,
                     imageURL: String? = nil,
                     imageData: Data? = nil,
                     cardSetID: String,
                     isFavorite: Bool = false,
                     types: [String] = []) {
        self.init()
        self.id = id
        self.name = name
        self.imageURL = imageURL
        self.imageData = imageData
        self.cardSetID = cardSetID
        self.isFavorite = isFavorite
        self.types.append(objectsIn: types)
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

extension Card: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case imageURL = "imageUrl"
    }
}

extension Card: Copyable {
    
    func createCopy() -> Card {

        return Card(id: id,
                    name: name,
                    imageURL: imageURL,
                    imageData: imageData,
                    cardSetID: cardSetID,
                    isFavorite: isFavorite,
                    types: Array(types))
    }
}
