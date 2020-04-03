//
//  MagicAPIResponses.swift
//  Bootcamp2020
//
//  Created by jacqueline alves barbosa on 18/03/20.
//  Copyright © 2020 Team2. All rights reserved.
//

import Foundation

class CardsResponse: Codable {
    var cards: [Card]
    
    init(cards: [Card]) {
        self.cards = cards
    }
}

class CardSetsResponse: Codable {
    var sets: [CardSet]
    
    init(sets: [CardSet]) {
        self.sets = sets
    }
}
