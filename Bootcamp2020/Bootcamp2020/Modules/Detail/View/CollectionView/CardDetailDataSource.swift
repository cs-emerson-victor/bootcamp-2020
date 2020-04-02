//
//  CardDetailDataSource.swift
//  Bootcamp2020
//
//  Created by alexandre.c.ferreira on 18/03/20.
//  Copyright © 2020 Team2. All rights reserved.
//

import UIKit

final class CardDetailDataSource: NSObject {
    
    var cards: [Card] = []
    
    var getViewModel: ((_ indexPath: IndexPath) -> CardCellViewModel)?
        
    func registerCells(on collectionView: UICollectionView) {
        collectionView.register(CardCell.self, forCellWithReuseIdentifier: CardCell.identifier)
    }
}

extension CardDetailDataSource: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards.count
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
}
