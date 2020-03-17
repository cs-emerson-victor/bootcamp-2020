//
//  Collection.swift
//  Bootcamp2020
//
//  Created by emerson.victor.f.luz on 17/03/20.
//  Copyright © 2020 Team2. All rights reserved.
//

import RealmSwift

final class Collection: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var releaseDate: Date = Date()
    let cards: List<Card> = List<Card>()
}

extension Collection: Codable {
    
}
