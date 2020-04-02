//
//  CardsAndSetsStub.swift
//  Bootcamp2020Tests
//
//  Created by Jacqueline Alves on 17/03/20.
//  Copyright © 2020 Team2. All rights reserved.
//

@testable import Bootcamp2020

import Foundation

class CardsAndSetsStub {
    lazy var fetchByNameCards: CardsResponse = {
        let card = Card(id: "1", name: "Abomination of Gudul", cardSetID: "1")
        
        return CardsResponse(cards: [card])
    }()
    
    lazy var fetchBySetCards: CardsResponse = {
        let card1 = Card(id: "1", name: "Abomination of Gudul", cardSetID: "1")
        let card2 = Card(id: "2", name: "Love of Gudul", cardSetID: "1")
        
        return CardsResponse(cards: [card1, card2])
    }()
    
    lazy var cardSets: CardSetsResponse = {
        let cardSet1 = CardSet(id: "1", name: "KTK", releaseDate: Date(), cards: self.fetchBySetCards.cards)
        let cardSet2 = CardSet(id: "2", name: "10E", releaseDate: Date())
        
        return CardSetsResponse(sets: [cardSet1, cardSet2])
    }()
}
