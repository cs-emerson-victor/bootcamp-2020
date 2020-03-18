//
//  CardsAndCollectionsStub.swift
//  Bootcamp2020Tests
//
//  Created by Jacqueline Alves on 17/03/20.
//  Copyright © 2020 Team2. All rights reserved.
//

@testable import Bootcamp2020

import Foundation

class CardsAndCollectionsStub {
    let fetchByNameCards: CardsResponse = {
        let card = Card()
        card.id = "1"
        card.name = "Abomination of Gudul"
        
        return CardsResponse(cards: [card])
    }()
    
    let collections: CollectionsResponse = {
        let cardSet1 = Collection(id: "1", name: "KTK")
        let cardSet2 = Collection(id: "2", name: "10E")
        
        return CollectionsResponse(sets: [cardSet1, cardSet2])
    }()
}
