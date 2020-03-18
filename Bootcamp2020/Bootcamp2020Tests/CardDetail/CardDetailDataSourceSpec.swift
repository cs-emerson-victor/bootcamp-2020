//
//  CardDetailDataSourceSpec.swift
//  Bootcamp2020Tests
//
//  Created by alexandre.c.ferreira on 18/03/20.
//  Copyright © 2020 Team2. All rights reserved.
//

import Quick
import Nimble
@testable import Bootcamp2020

final class CardDetailDataSourceSpec: QuickSpec {
    
    override func spec() {
        
        var sut: CardDetailDataSource!
        var selectedIndexPath: IndexPath?
        var collectionView: UICollectionView!
        var viewModelHandler: ((_ indexPath: IndexPath) -> CardCellViewModel)!
        var cards: [Card]!
        
        beforeEach {
            viewModelHandler = { indexPath in
                selectedIndexPath = indexPath
                return CardCellViewModel(card: Card())
            }
            
            cards = CardSetStub().getCardsOfSet(CardSet(id: "1", name: "Set 1"))
            sut = CardDetailDataSource()
            sut.getViewModel = viewModelHandler
            sut.cards = cards
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collectionView.dataSource = sut
            sut.registerCells(on: collectionView)
        }
        
        afterEach {
            selectedIndexPath = nil
            sut = nil
            cards = nil
            collectionView = nil
        }
        
        describe("CardDetailDataSource") {
            
            it("should have the correct number of items") {
                expect(sut.collectionView(collectionView, numberOfItemsInSection: 0)).to(equal(cards.count))
            }
            
            it("should have registered the correct cells") {
                
                // Act
                let cardCell = collectionView.dequeueReusableCell(withReuseIdentifier: CardCell.identifier, for: IndexPath(item: 3, section: 0))
                
                // Assert
                expect(cardCell).to(beAKindOf(CardCell.self))
            }
            
            context("when loading section") {
                
            }
            
            context("when loading cell data") {
                it("should call the view model handler with the correct index path") {
                    // Arrange
                    let indexPath = IndexPath(item: 2, section: 0)
                    
                    // Act
                    _ = sut.collectionView(collectionView, cellForItemAt: indexPath)
                    
                    // Assert
                    expect(selectedIndexPath).toNot(beNil())
                    expect(selectedIndexPath).to(equal(indexPath))
                }
                
                it("should load the last cell") {
                    
                    // Act
                    let indexPath = IndexPath(item: cards.count - 1, section: 0)
                    let cell = sut.collectionView(collectionView, cellForItemAt: indexPath) as? CardCell
                    
                    // Arrange
                    expect(cell).toNot(beNil())
                }
            }
        }
    }
}
