//
//  CardSet.swift
//  Bootcamp2020
//
//  Created by emerson.victor.f.luz on 17/03/20.
//  Copyright © 2020 Team2. All rights reserved.
//

import Foundation

final class CardSet {
    let id: String
    let name: String
    let releaseDate: Date
    var cards: [Card] = [] {
        didSet {
            cards.sort(by: { $0.name < $1.name })
        }
    }
    
    init(id: String, name: String, releaseDate: Date = Date(), cards: [Card] = []) {
        self.id = id
        self.name = name
        self.releaseDate = releaseDate
        self.cards.append(contentsOf: cards)
    }
    
    convenience init(set: RealmCardSet) {
        self.init(id: set.id, name: set.name, releaseDate: set.releaseDate)
        self.cards = set.cards.map({ (card) -> Card in
            return Card(card: card)
        })
    }
}

extension CardSet: Equatable {
    static func == (lhs: CardSet, rhs: CardSet) -> Bool {
        return lhs.id == rhs.id
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
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let id = try container.decode(String.self, forKey: .id)
        let name = try container.decode(String.self, forKey: .name)
        let dateString = try container.decode(String.self, forKey: .releaseDate)

        guard let date = CardSet.dateFormatter.date(from: dateString) else {
            self.init(id: id, name: name)
            return
        }
        
        self.init(id: id, name: name, releaseDate: date)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)

        try container.encode(CardSet.dateFormatter.string(from: releaseDate), forKey: .releaseDate)
    }
}
