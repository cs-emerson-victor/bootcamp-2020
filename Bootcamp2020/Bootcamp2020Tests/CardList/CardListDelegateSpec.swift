//
//  CardListDelegateSpec.swift
//  Bootcamp2020Tests
//
//  Created by alexandre.c.ferreira on 16/03/20.
//  Copyright © 2020 Team2. All rights reserved.
//

@testable import Bootcamp2020
import Quick
import Nimble

final class CardListDelegateSpec: QuickSpec {
    
    override func spec() {
        
        var sut: CardListDelegate!
        var collectionView: UICollectionView!
        var dataSource: CardListDataSourceStub!
        var selectedItem: Int?
        
        beforeEach {
            
            dataSource = CardListDataSourceStub()
            sut = CardListDelegate()
            sut.didSelectItemAt = { item in
                selectedItem = item
            }
            collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
            collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
            collectionView.dataSource = dataSource
            collectionView.delegate = sut
        }
        
        afterEach {
            
            sut = nil
            collectionView = nil
            selectedItem = nil
            dataSource = nil
        }
        
        describe("CardListDelegate") {
            context("when selecting an item") {
                it("should call the selection closure") {
                    // Arrange
                    let indexPath = IndexPath(item: 2, section: 0)
                    collectionView.reloadData()
                    
                    // Act
                    sut.collectionView(collectionView, didSelectItemAt: indexPath)
                    
                    // Assert
                    expect(selectedItem).toNot(beNil())
                    expect(selectedItem).to(equal(indexPath.item))
                }
            }
        }
    }
}
