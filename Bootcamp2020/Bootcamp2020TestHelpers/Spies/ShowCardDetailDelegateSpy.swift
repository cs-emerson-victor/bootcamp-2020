//
//  ShowCardDetailDelegateSpy.swift
//  Bootcamp2020
//
//  Created by jacqueline alves barbosa on 26/03/20.
//  Copyright © 2020 Team2. All rights reserved.
//

import Foundation
@testable import Bootcamp2020

class ShowCardDetailDelegateSpy: ShowCardDetailDelegate {
    var saver: CardSaverProtocol {
        return LocalServiceDummy()
    }
    
    var didShowCardSet: Bool = false
    var showedCardSet: CardSet?
    var selectedCardId: String?
    
    func show(_ cardSet: CardSet, selectedCardId id: String) {
        didShowCardSet = true
        showedCardSet = cardSet
        selectedCardId = id
    }
}
