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
    let categories: List<Category> = List<Category>()
}

extension Card: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case imageURL = "imageUrl"
    }
}
