//
//  CardListDataSourceSpec.swift
//  Bootcamp2020Tests
//
//  Created by alexandre.c.ferreira on 17/03/20.
//  Copyright © 2020 Team2. All rights reserved.
//

import Quick
import Nimble
@testable import Bootcamp2020

final class CardListDataSourceSpec: QuickSpec {
    
    override func spec() {
        
        var sut: CardListDataSource!
        var selectedIndexPath: IndexPath?
        var collectionView: UICollectionView!
        var viewModelHandler: ((_ indexPath: IndexPath) -> CardCellViewModel)!
        var collections: [Collection]!
        
        beforeEach {
            viewModelHandler = { indexPath in
                selectedIndexPath = indexPath
                return CardCellViewModel()
            }
            // TODO: Fill with collections stubs
            collections = []
            sut = CardListDataSource()
            sut.getViewModel = viewModelHandler
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collectionView.dataSource = sut
        }
        
        afterEach {
            selectedIndexPath = nil
            sut = nil
            collectionView = nil
        }
        
        describe("CardListDataSource") {
            
            it("should have the correct number of sections") {
                expect(sut.numberOfSections(in: collectionView)).to(equal(collections.count))
            }
            
//            context("when loading section") {
//                it("should have the correct number of items") {
//                    let section: Int = 0
//                    expect(sut.collectionView(collectionView, numberOfItemsInSection: section)).to(equal(collections[section].cards?.count))
//                }
//            }
        }
    }
}
