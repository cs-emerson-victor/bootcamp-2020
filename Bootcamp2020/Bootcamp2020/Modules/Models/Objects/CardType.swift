//
//  CardType.swift
//  Bootcamp2020
//
//  Created by emerson.victor.f.luz on 17/03/20.
//  Copyright © 2020 Team2. All rights reserved.
//

import RealmSwift

final class CardType: Object {
    @objc dynamic var name: String = ""
    
    convenience init(name: String) {
        self.init()
        self.name = name
    }
    
    override static func primaryKey() -> String? {
        return "name"
    }
}

extension CardType: Codable {
    
}
