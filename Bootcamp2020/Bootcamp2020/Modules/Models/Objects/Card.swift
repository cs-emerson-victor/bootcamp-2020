//
//  Card.swift
//  Bootcamp2020
//
//  Created by emerson.victor.f.luz on 17/03/20.
//  Copyright © 2020 Team2. All rights reserved.
//

import Foundation

final class Card {
    let id: String
    let name: String
    var imageURL: String?
    var imageData: Data?
    let cardSetID: String
    var isFavorite: Bool
    var types: [String] = []

    init(id: String,
         name: String,
         imageURL: String? = nil,
         imageData: Data? = nil,
         cardSetID: String,
         isFavorite: Bool = false,
         types: [String] = []) {
        
        self.id = id
        self.name = name
        self.imageURL = imageURL
        self.imageData = imageData
        self.cardSetID = cardSetID
        self.isFavorite = isFavorite
        self.types.append(contentsOf: types)
    }
    
    convenience init(card: RealmCard) {
        self.init(id: card.id,
                  name: card.name,
                  imageURL: card.imageURL,
                  imageData: card.imageData,
                  cardSetID: card.cardSetID,
                  isFavorite: true,
                  types: Array(card.types))
    }
}

extension Card: Equatable {
    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.id == rhs.id
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
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let id = try container.decode(String.self, forKey: .id)
        let name = try container.decode(String.self, forKey: .name)
        let imageURL = try container.decodeIfPresent(String.self, forKey: .imageURL)
        let cardSetID = try container.decode(String.self, forKey: .cardSetID)
        let types = try container.decode([String].self, forKey: .types)
        
        self.init(id: id, name: name, imageURL: imageURL, cardSetID: cardSetID, types: types)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(imageURL, forKey: .imageURL)
        try container.encode(cardSetID, forKey: .cardSetID)
        try container.encode(types, forKey: .types)
    }
}
