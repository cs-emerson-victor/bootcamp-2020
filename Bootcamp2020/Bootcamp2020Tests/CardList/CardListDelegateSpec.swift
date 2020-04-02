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
        var delegateProtocol: CardListDelegateProtocolSpy!
        
        beforeEach {
            
            dataSource = CardListDataSourceStub()
            delegateProtocol = CardListDelegateProtocolSpy()
            sut = CardListDelegate()
            sut.delegateProtocol = delegateProtocol
            collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
            collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
            collectionView.dataSource = dataSource
            collectionView.delegate = sut
        }
        
        afterEach {
            delegateProtocol = nil
            sut = nil
            collectionView = nil
            dataSource = nil
        }
        
        describe("CardListDelegate") {
            context("when selecting an item") {
                it("should call the delegate protocol") {
                    // Arrange
                    let indexPath = IndexPath(item: 2, section: 0)
                    collectionView.reloadData()
                    
                    // Act
                    sut.collectionView(collectionView, didSelectItemAt: indexPath)
                    
                    // Assert
                    expect(delegateProtocol.indexPathOfSelectedItem).toNot(beNil())
                    expect(delegateProtocol.indexPathOfSelectedItem).to(equal(indexPath))
                }
            }
        }
    }
}
