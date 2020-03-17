//
//  CardSetHeaderCell.swift
//  Bootcamp2020
//
//  Created by jacqueline alves barbosa on 13/03/20.
//  Copyright © 2020 Team2. All rights reserved.
//

import UIKit

final class CardSetHeaderCell: UICollectionViewCell {
    
    let cardSetTitleLable: UILabel = {
        let label = UILabel()
        label.accessibilityIdentifier = "cardSetTitleLable"
        label.font = .boldSystemFont(ofSize: 36)
        label.numberOfLines = 0
        label.textAlignment = .natural
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        accessibilityIdentifier = "cardSetHeaderCell"
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CardSetHeaderCell: ViewCode {
    func buildViewHierarchy() {
        contentView.addSubview(cardSetTitleLable)
    }
    
    func setupConstraints() {
        cardSetTitleLable.snp.makeConstraints { (make) in
            make.margins.equalToSuperview()
        }
    }
}
