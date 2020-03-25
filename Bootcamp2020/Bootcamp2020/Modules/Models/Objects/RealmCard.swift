//
//  RealmCard.swift
//  Bootcamp2020
//
//  Created by emerson.victor.f.luz on 25/03/20.
//  Copyright © 2020 Team2. All rights reserved.
//

import RealmSwift

final class RealmCard: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var imageURL: String?
    @objc dynamic var imageData: Data?
    @objc dynamic var cardSetID: String = ""
    let types: List<String> = List<String>()

    convenience init(card: Card) {
        self.init()
        self.id = card.id
        self.name = card.name
        self.imageURL = card.imageURL
        self.imageData = card.imageData
        self.cardSetID = card.cardSetID
        self.types.append(objectsIn: card.types)
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
