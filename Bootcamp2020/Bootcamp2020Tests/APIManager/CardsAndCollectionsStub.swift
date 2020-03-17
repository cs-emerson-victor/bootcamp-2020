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
        card.name = "Abomination of Gudul"
        
        return CardsResponse(cards: [card])
    }()
}
