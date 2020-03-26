//
//  LeftAlignedFlowLayout.swift
//  Bootcamp2020
//
//  Created by alexandre.c.ferreira on 26/03/20.
//  Copyright © 2020 Team2. All rights reserved.
//

import UIKit

class LeftAlignedFlowLayout: UICollectionViewFlowLayout {

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)

        guard let flowLayoutDelegate = collectionView?.delegate as? UICollectionViewDelegateFlowLayout,
              let collectionView = collectionView,
              let insets = flowLayoutDelegate.collectionView?(collectionView, layout: self, insetForSectionAt: 0),
              let interitemSpacing = flowLayoutDelegate.collectionView?(collectionView, layout: self, minimumInteritemSpacingForSectionAt: 0) else {
            return attributes
        }
        var leftMargin = insets.left
        var maxY: CGFloat = -1.0
        attributes?.forEach { layoutAttribute in
            guard layoutAttribute.representedElementCategory == .cell else {
                return
            }
            
            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = insets.left
            }

            layoutAttribute.frame.origin.x = leftMargin

            leftMargin += layoutAttribute.frame.width + interitemSpacing
            maxY = max(layoutAttribute.frame.maxY, maxY)
        }

        return attributes
    }
}
