//
//  CardDetailScreen.swift
//  Bootcamp2020
//
//  Created by jacqueline alves barbosa on 13/03/20.
//  Copyright © 2020 Team2. All rights reserved.
//

import UIKit

final class CardDetailScreen: UIView {
    
    // MARK: - Properties -
    private let cardDetailCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.showsVerticalScrollIndicator = false
        view.accessibilityLabel = "cardDetailCollectionView"
        view.accessibilityIdentifier = "cardDetailCollectionView"
        view.backgroundColor = .clear
        view.isPagingEnabled = true
        return view
    }()
    
    private let detailBackgroundImageView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "backgroundImage"))
        view.accessibilityLabel = "detailBackgroundImageView"
        return view
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton()
        button.accessibilityLabel = "closeButton"
        button.setImage(UIImage(named: "close"), for: .normal)
        return button
    }()
    
    private let favoriteButton = FavoriteButton()
    
    var cardDetailDataSource: CardDetailDataSource
    var cardDetailDelegate: CardDetailDelegate //swiftlint:disable:this weak_delegate
    private(set) var viewModel: CardDetailViewModel!
    
    // MARK: - Init -
    init(dataSource: CardDetailDataSource = CardDetailDataSource(),
         delegate: CardDetailDelegate = CardDetailDelegate()) {
        self.cardDetailDataSource = dataSource
        self.cardDetailDelegate = delegate
        super.init(frame: .zero)
        self.accessibilityLabel = "CardDetailScreen"
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods -
    func bind(to viewModel: CardDetailViewModel) {
        self.viewModel = viewModel
        
        // TODO: Implement binding to view model
        cardDetailCollectionView.reloadData()
    }
}

extension CardDetailScreen: ViewCode {
    
    func buildViewHierarchy() {
        addSubview(detailBackgroundImageView)
        addSubview(cardDetailCollectionView)
        addSubview(closeButton)
        addSubview(favoriteButton)
    }
    
    func setupConstraints() {
        detailBackgroundImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        cardDetailCollectionView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.centerYWithinMargins.equalToSuperview()
            make.height.equalTo(UIScreen.main.bounds.width * (264/320))
        }
        
        closeButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(44)
            make.topMargin.equalToSuperview().offset(1)
            make.leading.equalToSuperview().offset(8)
        }
        
        favoriteButton.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().inset(16)
            make.bottomMargin.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
    }
    
    func setupAdditionalConfiguration() {
        cardDetailDataSource.registerCells(on: cardDetailCollectionView)
        cardDetailCollectionView.dataSource = cardDetailDataSource
        cardDetailCollectionView.delegate = cardDetailDelegate
    }
}
