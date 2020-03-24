//
//  CardDetailDelegate.swift
//  Bootcamp2020
//
//  Created by alexandre.c.ferreira on 18/03/20.
//  Copyright © 2020 Team2. All rights reserved.
//

import UIKit

final class CardDetailDelegate: NSObject {
    
    var numberOfItems: Int = 0
    var cellAtCenterDidChange: ((IndexPath) -> Void)?
    fileprivate var cellAspectRatio: CGFloat = 85/118
}

extension CardDetailDelegate: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let height = collectionView.frame.height
        let width = height * cellAspectRatio
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        let itemSize = self.collectionView(collectionView, layout: collectionViewLayout, sizeForItemAt: IndexPath(item: 0, section: 0))
        let leftInset = collectionView.frame.width / 2 - itemSize.width / 2
        let rightInset = leftInset
        
        return UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        guard let collectionView = scrollView as? UICollectionView else {
            return
        }
        
        let itemSize = self.collectionView(collectionView, layout: collectionView.collectionViewLayout, sizeForItemAt: IndexPath(item: 0, section: 0))
        let itemSpacing = self.collectionView(collectionView, layout: collectionView.collectionViewLayout, minimumInteritemSpacingForSectionAt: 0)
        
        let pageWidth = itemSize.width + itemSpacing
        let targetXContentOffset = targetContentOffset.pointee.x
        let newPage = ceil((targetXContentOffset - pageWidth / 2) / pageWidth)

        let targetPoint = CGPoint(x: newPage * pageWidth, y: targetContentOffset.pointee.y)
        targetContentOffset.pointee = targetPoint
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if let collectionView = scrollView as? UICollectionView {
            
            if let indexPath = collectionView.indexPathForItem(at: CGPoint(x: collectionView.contentOffset.x + collectionView.frame.width / 2, y: collectionView.frame.height / 2)) {
                
                cellAtCenterDidChange?(indexPath)
            }
        }
    }
}
