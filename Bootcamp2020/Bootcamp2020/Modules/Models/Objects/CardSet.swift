//
//  CardSet.swift
//  Bootcamp2020
//
//  Created by emerson.victor.f.luz on 17/03/20.
//  Copyright © 2020 Team2. All rights reserved.
//

import RealmSwift

final class CardSet: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var releaseDate: Date = Date()
    let cards: List<Card> = List<Card>()
    
    convenience init(id: String, name: String, releaseDate: Date = Date(), cards: [Card] = []) {
        self.init()
        self.id = id
        self.name = name
        self.releaseDate = releaseDate
        self.cards.append(objectsIn: cards)
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

extension CardSet: Codable {
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return dateFormatter
    }()
    
    enum CodingKeys: String, CodingKey {
        case id = "code"
        case name
        case releaseDate
    }
    
    convenience init(from decoder: Decoder) throws {
        self.init()
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        
        let dateString = try container.decode(String.self, forKey: .releaseDate)
        if let date = CardSet.dateFormatter.date(from: dateString) {
            self.releaseDate = date
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        
        try container.encode(CardSet.dateFormatter.string(from: releaseDate), forKey: .releaseDate)
    }
}

extension CardSet: Copyable {
    
    func createCopy() -> CardSet {
        return CardSet(id: id, name: name, releaseDate: releaseDate, cards: Array(cards))
    }
}
