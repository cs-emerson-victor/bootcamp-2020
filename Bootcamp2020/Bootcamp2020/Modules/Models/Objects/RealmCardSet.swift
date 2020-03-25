//
//  RealmCardSet.swift
//  Bootcamp2020
//
//  Created by emerson.victor.f.luz on 25/03/20.
//  Copyright © 2020 Team2. All rights reserved.
//

import RealmSwift

final class RealmCardSet: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var releaseDate: Date = Date()
    let cards: List<RealmCard> = List<RealmCard>()
    
    convenience init(set: CardSet) {
        self.init()
        self.id = set.id
        self.name = set.name
        self.releaseDate = set.releaseDate
        set.cards.forEach { (card) in
            self.cards.append(RealmCard(card: card))
        }
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
