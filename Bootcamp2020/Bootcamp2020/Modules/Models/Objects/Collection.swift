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
    enum CodingKeys: String, CodingKey {
        case id = "code"
        case name
        case releaseDate
    }
    
    convenience init(id: String, name: String, releaseDate: Date? = nil) {
        self.init()
        self.id = id
        self.name = name
        if let releaseDate = releaseDate { self.releaseDate = releaseDate }
    }
    
    convenience init(from decoder: Decoder) throws {
        self.init()
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let dateString = try container.decode(String.self, forKey: .releaseDate)
        if let date = dateFormatter.date(from: dateString) {
            self.releaseDate = date
        }
    }
}
