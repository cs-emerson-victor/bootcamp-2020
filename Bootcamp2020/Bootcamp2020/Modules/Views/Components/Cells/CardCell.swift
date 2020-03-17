//
//  CardCell.swift
//  Bootcamp2020
//
//  Created by jacqueline alves barbosa on 13/03/20.
//  Copyright © 2020 Team2. All rights reserved.
//

import UIKit

final class CardCell: UICollectionViewCell {
    
    // MARK: Properties
    private let cardImageView: UIImageView = {
        let view = UIImageView()
        view.accessibilityIdentifier = "cardCellImageView"
        return view
    }()
    
    var viewModel: CardCellViewModel!
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        accessibilityIdentifier = "cardCell"
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Methods
    func bind(to viewModel: CardCellViewModel) {
        self.viewModel = viewModel
        // TODO: Bind to CardCellViewModel
    }
}

extension CardCell: ViewCode {
    
    func buildViewHierarchy() {
        contentView.addSubview(cardImageView)
    }
    
    func setupConstraints() {
        cardImageView.snp.makeConstraints { (make) in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
    }
}
