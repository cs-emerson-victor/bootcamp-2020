//
//  CardListDelegateProtocolSpy.swift
//  Bootcamp2020
//
//  Created by alexandre.c.ferreira on 25/03/20.
//  Copyright © 2020 Team2. All rights reserved.
//

import Foundation
@testable import Bootcamp2020

final class CardListDelegateProtocolSpy: CardListDelegateProtocol {
    
    var indexPathOfSelectedItem: IndexPath?
    var sets = CardSetStub().getFullSets()
    
    func didSelectItem(at indexPath: IndexPath) {
        indexPathOfSelectedItem = indexPath
    }
    
    func didScroll() {
        
    }
    
    func getCellType(forItemAt indexPath: IndexPath) -> CellType {
        return .card(CardCellViewModel(card: Card()))
    }
}
