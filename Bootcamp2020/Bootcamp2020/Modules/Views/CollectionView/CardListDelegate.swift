//
//  CardListDelegate.swift
//  Bootcamp2020
//
//  Created by jacqueline alves barbosa on 13/03/20.
//  Copyright © 2020 Team2. All rights reserved.
//

import UIKit

protocol CardListDelegateProtocol: AnyObject {
    func didSelectItem(at indexPath: IndexPath)
    func didScroll()
    func getCellType(forItemAt indexPath: IndexPath) -> CellType
}

final class CardListDelegate: NSObject {
    
    weak var delegateProtocol: CardListDelegateProtocol?
    fileprivate var cardCellAspectRatio: CGFloat = 85/118
}

extension CardListDelegate: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegateProtocol?.didSelectItem(at: indexPath)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegateProtocol?.didScroll()
    }
}

extension CardListDelegate: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        guard let cellType = delegateProtocol?.getCellType(forItemAt: indexPath) else {
            return .zero
        }
        let insets = self.collectionView(collectionView, layout: collectionViewLayout, insetForSectionAt: indexPath.section)
        
        switch cellType {
        case .card:
            // Width for 3 items per row, which is (screen size - spaces)/3
            let numberOfItemsPerRow: CGFloat = 3
            let minimumInteritemSpacing = self.collectionView(collectionView, layout: collectionViewLayout, minimumInteritemSpacingForSectionAt: indexPath.section)
            let totalSpacing = minimumInteritemSpacing * (numberOfItemsPerRow - 1) + insets.left + insets.right
            let width = (collectionView.frame.width - totalSpacing) / 3 - 0.1
            let height = width / cardCellAspectRatio
            return CGSize(width: width, height: height)
        case .typeHeader:
            return CGSize(width: collectionView.frame.width - insets.left - insets.right, height: 17)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width - 16 * 2, height: 88)
    }
}
