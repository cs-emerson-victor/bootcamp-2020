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
        
        afterEach {
            sut = nil
            dataSource = nil
            delegate = nil
        }
        
        describe("CardListScreen") {
            context("when initialized") {
                it("should have added its subviews") {
                    
                    // Act
                    var hasSearchBar = false
                    var hasCollectionView = false
                    var hasBackgroundImageView = false
                    for view in sut.subviews {
                        switch view.accessibilityLabel {
                        case "listCollectionView":
                            hasCollectionView = true
                        case "listSearchBar":
                            hasSearchBar = true
                        case "backgroundImageView":
                            hasBackgroundImageView = true
                        default:
                            break
                        }
                    }
                    
                    // Assert
                    expect(hasBackgroundImageView).to(beTrue())
                    expect(hasCollectionView).to(beTrue())
                    expect(hasSearchBar).to(beTrue())
                }
                
                it("should have the correct given objects") {
                    
                    expect(sut.cardDataSource).to(beIdenticalTo(dataSource))
                    expect(sut.cardDelegate).to(beIdenticalTo(delegate))
                }
            }
            
            // TODO: Test binding ViewModel
            // TODO: Test states
        }
    }
}
