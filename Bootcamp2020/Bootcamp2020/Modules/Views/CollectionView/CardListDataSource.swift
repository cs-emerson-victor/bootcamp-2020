//
//  CardListDataSource.swift
//  Bootcamp2020
//
//  Created by jacqueline alves barbosa on 13/03/20.
//  Copyright © 2020 Team2. All rights reserved.
//

import UIKit

protocol CardListDataSourceProtocol {
    var numberOfSections: Int { get }
    func numberOfItems(in section: Int) -> Int
    func getCellType(forItemAt indexPath: IndexPath) -> CellType
    func getSetHeaderName(in section: Int) -> String
}

final class CardListDataSource: NSObject {
    
    var dataSourceProtocol: CardListDataSourceProtocol?
        
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
        return dataSourceProtocol?.numberOfSections ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSourceProtocol?.numberOfItems(in: section) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cellType = dataSourceProtocol?.getCellType(forItemAt: indexPath) else {
            fatalError("CollectionView \(collectionView) had no way to get the cell type")
        }
        
        switch cellType {
        case .card(let viewModel):
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardCell.identifier, for: indexPath) as? CardCell else {
                fatalError("Cell of collectionView \(collectionView) had a unregistered cell")
            }
            cell.bind(to: viewModel)
            return cell
            
        case .typeHeader(let title):
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardTypeHeaderCell.identifier,
                                                                for: indexPath) as? CardTypeHeaderCell else {
                fatalError("Cell of collectionView \(collectionView) had a unregistered cell")
            }
            cell.typeTitleLabel.text = title
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard let headerCell = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                               withReuseIdentifier: CardSetHeaderCell.identifier,
                                                                               for: indexPath) as? CardSetHeaderCell else {
            fatalError("Cell of collectionView \(collectionView) had a wrong cell")
        }
        
        headerCell.cardSetTitleLable.text = dataSourceProtocol?.getSetHeaderName(in: indexPath.section)
        
        return headerCell
    }
}
