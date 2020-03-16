//
//  CardListScreenSpec.swift
//  Bootcamp2020Tests
//
//  Created by alexandre.c.ferreira on 16/03/20.
//  Copyright © 2020 Team2. All rights reserved.
//

import Quick
import Nimble
@testable import Bootcamp2020

final class CardListScreenSpec: QuickSpec {
    
    override func spec() {
        
        var dataSource: CardListDataSource!
        var delegate: CardListDelegate!
        var sut: CardListScreen!
        
        beforeEach {
            
            dataSource = CardListDataSource()
            delegate = CardListDelegate()
            
            sut = CardListScreen(dataSource: dataSource, delegate: delegate)
        }
    }
}
