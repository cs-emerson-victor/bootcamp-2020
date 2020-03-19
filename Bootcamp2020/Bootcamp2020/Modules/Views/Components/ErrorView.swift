//
//  ErrorView.swift
//  Bootcamp2020
//
//  Created by alexandre.c.ferreira on 19/03/20.
//  Copyright © 2020 Team2. All rights reserved.
//

import UIKit
import SnapKit

final class ErrorView: UIView {
    // MARK: - Properties -
    let imageView: UIImageView = {
        let view = UIImageView(image: #imageLiteral(resourceName: "close"))
        view.contentMode = .scaleAspectFit
        view.accessibilityLabel = "errorImageView"
        return view
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.text = "Error: something went wrong.\nPlease try again."
        label.textAlignment = .center
        label.textColor = .white
        label.numberOfLines = 0
        label.accessibilityLabel = "errorLabel"
        return label
    }()
    
    // MARK: - Init -
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods -
    func display(message: String) {
        label.text = message
    }
}

extension ErrorView: ViewCode {
    func buildViewHierarchy() {
        addSubview(imageView)
        addSubview(label)
    }
    
    func setupConstraints() {
        imageView.snp.makeConstraints { (make) in
            make.height.width.equalTo(44)
            make.centerX.equalToSuperview()
            make.top.greaterThanOrEqualToSuperview()
            make.bottom.equalTo(self.snp.centerY).priority(999)
        }
        
        label.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
            make.top.equalTo(imageView.snp.bottom).offset(10)
        }
    }
    
    func setupAdditionalConfiguration() {
        layer.cornerRadius = 5
        clipsToBounds = true
        backgroundColor = UIColor.black.withAlphaComponent(0.4)
    }
}
