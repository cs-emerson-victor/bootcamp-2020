//
//  CollectionHeaderCell.swift
//  Bootcamp2020
//
//  Created by jacqueline alves barbosa on 13/03/20.
//  Copyright © 2020 Team2. All rights reserved.
//

import UIKit

final class CollectionHeaderCell: UICollectionViewCell {
    
    let collectionTitleLable: UILabel = {
        let label = UILabel()
        label.accessibilityIdentifier = "collectionTitleLable"
        label.font = .boldSystemFont(ofSize: 36)
        label.numberOfLines = 0
        label.textAlignment = .natural
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        accessibilityIdentifier = "collectionHeaderCell"
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CollectionHeaderCell: ViewCode {
    func buildViewHierarchy() {
        contentView.addSubview(collectionTitleLable)
    }
    
    func setupConstraints() {
        collectionTitleLable.snp.makeConstraints { (make) in
            make.margins.equalToSuperview()
        }
    }
}
