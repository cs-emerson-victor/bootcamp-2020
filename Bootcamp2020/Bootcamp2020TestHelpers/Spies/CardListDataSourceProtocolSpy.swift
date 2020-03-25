//
//  CardListDataSourceProtocolSpy.swift
//  Bootcamp2020
//
//  Created by alexandre.c.ferreira on 25/03/20.
//  Copyright © 2020 Team2. All rights reserved.
//

import Foundation
@testable import Bootcamp2020

final class CardListDataSourceProtocolSpy: CardListDataSourceProtocol {
    
    let sets = CardSetStub().getFullSets()
    
    var lastSelectedIndexPath: IndexPath?
    var lastSelectedSection: Int?
    
    var numberOfSections: Int {
        return sets.count
    }
    
    func numberOfItems(in section: Int) -> Int {
        lastSelectedSection = section
        return sets[section].cards.count
    }
    
    func getCellTypeForDataSource(forItemAt indexPath: IndexPath) -> CellType {
        lastSelectedIndexPath = indexPath
        lastSelectedSection = indexPath.section
        return .card(CardCellViewModel(card: sets[indexPath.section].cards[indexPath.item]))
    }
    
    func getSetHeaderName(in section: Int) -> String {
        lastSelectedSection = section
        return sets[section].name
    }
}
