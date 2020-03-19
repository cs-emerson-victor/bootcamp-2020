//
//  CardCell.swift
//  Bootcamp2020
//
//  Created by jacqueline alves barbosa on 13/03/20.
//  Copyright © 2020 Team2. All rights reserved.
//

import UIKit
import Kingfisher

final class CardCell: UICollectionViewCell {
    
    // MARK: Properties
    private let cardImageView: UIImageView = {
        let view = UIImageView()
        view.accessibilityIdentifier = "cardCellImageView"
        view.accessibilityLabel = "cardCellImageView"
        return view
    }()
    
    var viewModel: CardCellViewModel!
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        accessibilityIdentifier = "cardCell"
        accessibilityLabel = "cardCell"
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Methods
    func bind(to viewModel: CardCellViewModel) {
        self.viewModel = viewModel
        // TODO: Treat nil imageData
        cardImageView.kf.setImage(with: viewModel.imageURL, placeholder: UIImage(named: "placeholder"))
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
