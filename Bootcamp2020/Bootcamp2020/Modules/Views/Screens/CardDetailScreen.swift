//
//  CardDetailScreen.swift
//  Bootcamp2020
//
//  Created by jacqueline alves barbosa on 13/03/20.
//  Copyright © 2020 Team2. All rights reserved.
//

import UIKit

class CardDetailScreen: UIView {
    
    // MARK: - Properties -
    private let nameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.accessibilityLabel = "cardNameLabel"
        label.font = .boldSystemFont(ofSize: 24)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    private let cardDetailCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.accessibilityLabel = "cardDetailCollectionView"
        view.accessibilityIdentifier = "cardDetailCollectionView"
        view.backgroundColor = .clear
        return view
    }()
    
    private let detailBackgroundImageView: UIView = {
        let view = UIView(frame: .zero)
        view.accessibilityLabel = "detailBackgroundImageView"
        view.backgroundColor = UIColor(red: 0.05, green: 0.05, blue: 0.05, alpha: 1.00)

        return view
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton()
        button.accessibilityLabel = "closeButton"
        button.setImage(UIImage(named: "close"), for: .normal)
        button.addTarget(self, action: #selector(closeTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    private let favoriteButton: FavoriteButton = {
        let button = FavoriteButton()
        button.addTarget(self, action: #selector(favoriteTapped(_:)), for: .touchUpInside)
        
        return button
    }()
    
    var cardDetailDataSource: CardDetailDataSource
    var cardDetailDelegate: CardDetailDelegate //swiftlint:disable:this weak_delegate
    private(set) var viewModel: CardDetailViewModel!
    
    var currentIndexPath: IndexPath!
    
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
        
        currentIndexPath = viewModel.firstSelectedIndexPath
        setFavoriteButtonTitle(isFavorite: viewModel.isCardFavorite(at: currentIndexPath))
        setNameLabel(to: viewModel.cardName(for: currentIndexPath))
        cardDetailDelegate.cellAtCenterDidChange = { [weak self] indexPath in
            let isFavorite = viewModel.isCardFavorite(at: indexPath)
            let cardName = viewModel.cardName(for: indexPath)
            self?.currentIndexPath = indexPath
            self?.setFavoriteButtonTitle(isFavorite: isFavorite)
            self?.setNameLabel(to: cardName)
        }
        cardDetailDataSource.getViewModel = viewModel.cellViewModel
        cardDetailDataSource.cards = viewModel.cards
        cardDetailCollectionView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) { [weak self] in
            guard let self = self else { return }
            self.cardDetailCollectionView.scrollToItem(at: self.currentIndexPath, at: .centeredHorizontally, animated: false)
        }
    }
    
    private func setFavoriteButtonTitle(isFavorite: Bool) {
        favoriteButton.setTitle(isFavorite ? "remove card from favorites" : "add card to favorites", for: .normal)
    }
    
    private func setNameLabel(to name: String) {
        nameLabel.text = name
    }
    
    @objc func favoriteTapped(_ sender: UIButton) {
        viewModel.toggleCardFavorite(at: currentIndexPath)
    }
    
    @objc func closeTapped(_ sender: UIButton?) {
        viewModel.dismissDetail()
    }
}

extension CardDetailScreen: ViewCode {
    
    func buildViewHierarchy() {
        addSubview(detailBackgroundImageView)
        addSubview(nameLabel)
        addSubview(cardDetailCollectionView)
        addSubview(favoriteButton)
        addSubview(closeButton)
    }
    
    func setupConstraints() {
        detailBackgroundImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().inset(16)
            make.topMargin.equalTo(closeButton.snp.bottomMargin).offset(10)
            make.height.equalTo(100)
        }
        
        cardDetailCollectionView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.centerYWithinMargins.equalToSuperview()
            make.height.equalTo(UIScreen.main.bounds.width * (264/320))
        }
        
        closeButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(44)
            make.topMargin.equalToSuperview().offset(25)
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
