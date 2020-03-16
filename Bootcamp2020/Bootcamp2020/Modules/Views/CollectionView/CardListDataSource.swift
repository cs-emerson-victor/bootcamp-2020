//
//  CardListDataSource.swift
//  Bootcamp2020
//
//  Created by jacqueline alves barbosa on 13/03/20.
//  Copyright © 2020 Team2. All rights reserved.
//

import UIKit

final class CardListDataSource: NSObject {
    
    var cellViewModels: [CardCellViewModel] = []
    
    func registerCells(on collectionView: UICollectionView) {
        collectionView.register(CardCell.self, forCellWithReuseIdentifier: CardCell.identifier)
        collectionView.register(CategoryHeaderCell.self, forCellWithReuseIdentifier: CategoryHeaderCell.identifier)
        collectionView.register(CollectionHeaderCell.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: CollectionHeaderCell.identifier)
    }
}

extension CardListDataSource: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // TODO: Implement cellForItemAt
        return UICollectionViewCell()
    }
}
