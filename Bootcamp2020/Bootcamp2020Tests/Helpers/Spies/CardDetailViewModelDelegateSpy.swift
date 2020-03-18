//
//  CardDetailViewModelDelegateSpy.swift
//  Bootcamp2020Tests
//
//  Created by emerson.victor.f.luz on 18/03/20.
//  Copyright © 2020 Team2. All rights reserved.
//

@testable import Bootcamp2020
import Foundation

class CardDetailViewModelDelegateSpy: CardDetailViewModelDelegate {
    
    private(set) var toggleFunctionWasCalled = false
    private(set) var card: Card?
    
    func toggleFavorite(_ card: Card) {
        toggleFunctionWasCalled = true
        self.card = card
    }
}
