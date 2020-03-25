//
//  CardListDataSourceSpec.swift
//  Bootcamp2020Tests
//
//  Created by alexandre.c.ferreira on 17/03/20.
//  Copyright © 2020 Team2. All rights reserved.
//
//swiftlint:disable function_body_length

import Quick
import Nimble
@testable import Bootcamp2020

final class CardListDataSourceSpec: QuickSpec {
    
    override func spec() {
        
        var sut: CardListDataSource!
        var selectedIndexPath: IndexPath?
        var collectionView: UICollectionView!
        var cellTypeHandler: ((_ indexPath: IndexPath) -> CellType)!
        var sets: [CardSet]!
        
        beforeEach {
            cellTypeHandler = { indexPath in
                selectedIndexPath = indexPath
                
                return .card(CardCellViewModel(card: Card()))
            }
            
            sets = CardSetStub().getFullSets()
            sut = CardListDataSource()
            sut.getCellType = cellTypeHandler
            sut.sets = sets
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collectionView.dataSource = sut
            sut.registerCells(on: collectionView)
        }
        
        afterEach {
            selectedIndexPath = nil
            sut = nil
            sets = nil
            collectionView = nil
        }
        
        describe("CardListDataSource") {
            
            it("should have the correct number of sections") {
                expect(sut.numberOfSections(in: collectionView)).to(equal(sets.count))
            }
            
            it("should have registered the correct cells") {
                
                // Act
                let cardCell = collectionView.dequeueReusableCell(withReuseIdentifier: CardCell.identifier, for: IndexPath(item: 3, section: 0))
                let typeHeaderCell = collectionView.dequeueReusableCell(withReuseIdentifier: CardTypeHeaderCell.identifier, for: IndexPath(item: 0, section: 0))
                let setHeaderCell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                                                    withReuseIdentifier: CardSetHeaderCell.identifier,
                                                                                    for: IndexPath(item: 0, section: 0))
                
                // Assert
                expect(cardCell).to(beAKindOf(CardCell.self))
                expect(typeHeaderCell).to(beAKindOf(CardTypeHeaderCell.self))
                expect(setHeaderCell).to(beAKindOf(CardSetHeaderCell.self))
            }
            
            context("when loading section") {
                it("should have the correct number of items") {
                    let section: Int = 0
                    expect(sut.collectionView(collectionView, numberOfItemsInSection: section)).to(equal(sets[section].cards.count))
                }
            }
            
            context("when loading cell data") {
                it("should call the view model handler with the correct index path") {
                    // Arrange
                    let indexPath = IndexPath(item: 2, section: 2)
                    
                    // Act
                    _ = sut.collectionView(collectionView, cellForItemAt: indexPath)
                    
                    // Assert
                    expect(selectedIndexPath).toNot(beNil())
                    expect(selectedIndexPath).to(equal(indexPath))
                }
                
                it("should load the last cell of the last section") {
                    
                    // Act
                    let indexPath = IndexPath(item: sets[sets.count - 1].cards.count - 1, section: sets.count - 1)
                    let cell = sut.collectionView(collectionView, cellForItemAt: indexPath) as? CardCell
                    
                    // Arrange
                    expect(cell).toNot(beNil())
                }
            }
        }
    }
}
