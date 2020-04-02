//
//  CardDetailDelegateSpec.swift
//  Bootcamp2020Tests
//
//  Created by alexandre.c.ferreira on 18/03/20.
//  Copyright © 2020 Team2. All rights reserved.
//

@testable import Bootcamp2020
import Quick
import Nimble

final class CardDetailDelegateSpec: QuickSpec {
    
    override func spec() {
        
        var sut: CardDetailDelegate!
        var collectionView: UICollectionView!
        var dataSource: CardListDataSourceStub!
        var layout: UICollectionViewFlowLayout!
        
        beforeEach {
            
            dataSource = CardListDataSourceStub()
            sut = CardDetailDelegate()
            layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
            collectionView.dataSource = dataSource
            collectionView.delegate = sut
        }
        
        afterEach {
            
            sut = nil
            layout = nil
            collectionView = nil
            dataSource = nil
        }
        
        describe("CardDetailDelegate") {
            context("when loading sizes") {
                it("should return the correct minimum interitem spacing") {
                    
                    expect(sut.collectionView(collectionView, layout: layout, minimumInteritemSpacingForSectionAt: 0)).to(equal(16))
                }
                
                it("should return the correct minimum line spacing") {
                    
                    expect(sut.collectionView(collectionView, layout: layout, minimumLineSpacingForSectionAt: 0)).to(equal(16))
                }
            }
        }
    }
}
