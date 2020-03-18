//
//  FavoriteButton.swift
//  Bootcamp2020
//
//  Created by jacqueline alves barbosa on 13/03/20.
//  Copyright © 2020 Team2. All rights reserved.
//

import UIKit

final class FavoriteButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        accessibilityLabel = "favoriteButton"
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FavoriteButton: ViewCode {
    func buildViewHierarchy() {
        
    }
    
    func setupConstraints() {
        
    }
    
    func setupAdditionalConfiguration() {
        layer.borderWidth = 1
        layer.borderColor = UIColor.white.cgColor
        layer.cornerRadius = 3
        clipsToBounds = true
        titleLabel?.font = .boldSystemFont(ofSize: 16)
        titleLabel?.textAlignment = .center
    }
}
