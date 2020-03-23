//
//  CardSaverSpy.swift
//  Bootcamp2020Tests
//
//  Created by emerson.victor.f.luz on 19/03/20.
//  Copyright © 2020 Team2. All rights reserved.
//

@testable import Bootcamp2020
import Foundation

final class CardSaverSpy: CardSaverProtocol {
    
    var cardWasSaved = false
    
    func toggleFavorite(_ card: Card, of set: CardSet) -> Error? {
        cardWasSaved = true
        return nil
    }
}
