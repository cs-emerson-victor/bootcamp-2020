//
//  CardListScreen.swift
//  Bootcamp2020
//
//  Created by jacqueline alves barbosa on 13/03/20.
//  Copyright © 2020 Team2. All rights reserved.
//

import UIKit
import SnapKit

final class CardListScreen: UIView {
    
    // MARK: - Properties -
    private let listCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.showsVerticalScrollIndicator = false
        view.accessibilityIdentifier = "listCollectionView"
        return view
    }()
    
    private let searchBar: UISearchBar = {
        let view = UISearchBar()
        view.accessibilityIdentifier = "listSearchBar"
        return view
    }()
    
    var cardDataSource: CardListDataSource
    
    var cardDelegate: CardListDelegate //swiftlint:disable:this weak_delegate
    
    var viewModel: CardListViewModel!
    
    // MARK: - Init -
    init(dataSource: CardListDataSource = CardListDataSource(),
         delegate: CardListDelegate = CardListDelegate()) {
        
        self.cardDataSource = dataSource
        self.cardDelegate = delegate
        super.init(frame: .zero)
        self.accessibilityIdentifier = "CardListScreen"
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods -
    func bind(to viewModel: CardListViewModel) {
        
        self.viewModel = viewModel
        // TODO: Implement bind to list VM
//        cardDelegate.didSelectItemAt = { (row) in
//
//        }
    }
}

// MARK: - ViewCode
extension CardListScreen: ViewCode {
    
    func buildViewHierarchy() {
        addSubview(listCollectionView)
        addSubview(searchBar)
    }
    
    func setupConstraints() {
        
        listCollectionView.snp.makeConstraints { (make) in
            make.leadingMargin.trailingMargin.bottomMargin.equalToSuperview()
            make.top.equalTo(searchBar.snp.bottom)
        }
        
        searchBar.snp.makeConstraints { (make) in
            make.leadingMargin.equalToSuperview().offset(16)
            make.trailingMargin.equalToSuperview().inset(16)
            make.topMargin.equalToSuperview().offset(23)
            make.height.equalTo(30)
        }
    }
    
    func setupAdditionalConfiguration() {
        cardDataSource.registerCells(on: listCollectionView)
        listCollectionView.dataSource = cardDataSource
        listCollectionView.delegate = cardDelegate
    }
}
