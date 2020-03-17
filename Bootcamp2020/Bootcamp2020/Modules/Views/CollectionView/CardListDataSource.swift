//
//  CardListDataSource.swift
//  Bootcamp2020
//
//  Created by jacqueline alves barbosa on 13/03/20.
//  Copyright © 2020 Team2. All rights reserved.
//

import UIKit

final class CardListDataSource: NSObject {
    
    var sets: [CardSet] = []
    
    var getViewModel: ((_ indexPath: IndexPath) -> CardCellViewModel)?
        
    func registerCells(on collectionView: UICollectionView) {
        collectionView.register(CardCell.self, forCellWithReuseIdentifier: CardCell.identifier)
        collectionView.register(CardTypeHeaderCell.self, forCellWithReuseIdentifier: CardTypeHeaderCell.identifier)
        collectionView.register(CardSetHeaderCell.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: CardSetHeaderCell.identifier)
    }
}

extension CardListDataSource: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sets[section].cards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardCell.identifier, for: indexPath) as? CardCell else {
            fatalError("Cell of collectionView \(collectionView) had a unregistered cell")
        }
        
        guard let viewModel = getViewModel?(indexPath) else {
            fatalError("Had no View Model for cell at indexPath \(indexPath)")
        }
        
        cell.bind(to: viewModel)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard let headerCell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                                               withReuseIdentifier: CardSetHeaderCell.identifier,
                                                                               for: indexPath) as? CardSetHeaderCell else {
            fatalError("Cell of collectionView \(collectionView) had a wrong cell")
        }
        
        headerCell.cardSetTitleLable.text = sets[indexPath.section].name
        
        return headerCell
    }
}
