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
        case cardSetID = "set"
        case types
    }
    
    convenience init(from decoder: Decoder) throws {
        self.init()
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.imageURL = try container.decodeIfPresent(String.self, forKey: .imageURL)
        self.cardSetID = try container.decode(String.self, forKey: .cardSetID)
        
        let types = try container.decode([String].self, forKey: .types)
        self.types.append(objectsIn: types)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(imageURL, forKey: .imageURL)
        try container.encode(cardSetID, forKey: .cardSetID)
        try container.encode(Array(types), forKey: .types)
    }
}
