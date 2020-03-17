//
//  CategoryHeaderCell.swift
//  Bootcamp2020
//
//  Created by jacqueline alves barbosa on 13/03/20.
//  Copyright © 2020 Team2. All rights reserved.
//

import UIKit

final class CategoryHeaderCell: UICollectionViewCell {
    
    let categoryTitleLable: UILabel = {
        let label = UILabel()
        label.accessibilityIdentifier = "categoryTitleLable"
        label.font = .boldSystemFont(ofSize: 14)
        label.numberOfLines = 0
        label.textAlignment = .natural
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        accessibilityIdentifier = "categoryHeaderCell"
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CategoryHeaderCell: ViewCode {
    func buildViewHierarchy() {
        contentView.addSubview(categoryTitleLable)
    }
    
    func setupConstraints() {
        categoryTitleLable.snp.makeConstraints { (make) in
            make.margins.equalToSuperview()
        }
    }
}
