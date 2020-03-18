//
//  CardTypeHeaderCell.swift
//  Bootcamp2020
//
//  Created by jacqueline alves barbosa on 13/03/20.
//  Copyright © 2020 Team2. All rights reserved.
//

import UIKit

final class CardTypeHeaderCell: UICollectionViewCell {
    
    let typeTitleLabel: UILabel = {
        let label = UILabel()
        label.accessibilityIdentifier = "typeTitleLabel"
        label.font = .boldSystemFont(ofSize: 14)
        label.numberOfLines = 0
        label.textAlignment = .natural
        label.textColor = .white
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        accessibilityIdentifier = "typeHeaderCell"
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CardTypeHeaderCell: ViewCode {
    func buildViewHierarchy() {
        contentView.addSubview(typeTitleLabel)
    }
    
    func setupConstraints() {
        typeTitleLabel.snp.makeConstraints { (make) in
            make.margins.equalToSuperview()
        }
    }
}
