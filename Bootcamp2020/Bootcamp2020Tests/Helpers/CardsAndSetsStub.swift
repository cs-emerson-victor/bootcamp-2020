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
    let fetchByNameCards: CardsResponse = {
        let card = Card()
        card.id = "1"
        card.name = "Abomination of Gudul"
        
        return CardsResponse(cards: [card])
    }()
    
    let cardSets: CardSetsResponse = {
        let cardSet1 = CardSet(id: "1", name: "KTK", releaseDate: Date())
        let cardSet2 = CardSet(id: "2", name: "10E", releaseDate: Date())
        
        return CardSetsResponse(sets: [cardSet1, cardSet2])
    }()
}
