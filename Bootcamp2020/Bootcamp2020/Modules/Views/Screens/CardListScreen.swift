//
//  CardListScreen.swift
//  Bootcamp2020
//
//  Created by jacqueline alves barbosa on 13/03/20.
//  Copyright © 2020 Team2. All rights reserved.
//

import UIKit
import SnapKit

class CardListScreen: UIView {
    
    // MARK: - Properties -
    private let listCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.showsVerticalScrollIndicator = false
        view.accessibilityLabel = "listCollectionView"
        view.accessibilityIdentifier = "listCollectionView"
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var searchBar: UISearchBar = {
        let view = UISearchBar()
        view.accessibilityLabel = "listSearchBar"
        view.isUserInteractionEnabled = false
        view.delegate = self
        return view
    }()
    
    private let backgroundImageView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "backgroundImage"))
        view.accessibilityLabel = "backgroundImageView"
        return view
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .whiteLarge)
        view.accessibilityLabel = "activityIndicator"
        view.hidesWhenStopped = true
        return view
    }()
    
    private let errorView: ErrorView = {
        let view = ErrorView()
        view.accessibilityLabel = "listErrorView"
        return view
    }()
    
    var cardDataSource: CardListDataSource
    
    var cardDelegate: CardListDelegate //swiftlint:disable:this weak_delegate
    
    private(set) var viewModel: CardListViewModel!
    
    var isLoading: Bool {
        guard viewModel != nil else { return false }
        switch viewModel.state {
        case .loading, .searching:
            return true
        default:
            return false
        }
    }
    
    // MARK: - Init -
    init(dataSource: CardListDataSource = CardListDataSource(),
         delegate: CardListDelegate = CardListDelegate()) {
        
        self.cardDataSource = dataSource
        self.cardDelegate = delegate
        super.init(frame: .zero)
        self.accessibilityLabel = "CardListScreen"
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods -
    func bind(to viewModel: CardListViewModel) {
        
        self.viewModel = viewModel
        
        cardDataSource.sets = viewModel.cardSets
        cardDataSource.getViewModel = viewModel.cellViewModel
        cardDelegate.didSelectItemAt = viewModel.didSelectCell
        
        switch viewModel.state {
        case .initialLoading:
            activityIndicator.startAnimating()
        case .success, .searchSuccess:
            DispatchQueue.main.async { [weak self] in
                self?.searchBar.isUserInteractionEnabled = true
                self?.hideError()
                self?.activityIndicator.stopAnimating()
                self?.listCollectionView.reloadData()
            }
        case .searching:
            DispatchQueue.main.async { [weak self] in
                self?.listCollectionView.reloadData()
                self?.activityIndicator.startAnimating()
                self?.hideError()
            }
        case .error:
            DispatchQueue.main.async { [weak self] in
                self?.displayError()
            }
        case .loading:
            DispatchQueue.main.async { [weak self] in
                self?.activityIndicator.startAnimating()
                self?.hideError()
            }
        }
    }
    
    // MARK: Error handling
    private func displayError() {
        errorView.display(message: viewModel.errorMessage)
        
        guard errorView.superview == nil else { return }
        
        addSubview(errorView)
        
        makeErrorViewConstraints()
    }
    
    private func hideError() {
        errorView.removeFromSuperview()
    }
    
    private func makeErrorViewConstraints() {
        errorView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            let width = UIScreen.main.bounds.width - 32
            make.width.equalTo(width)
            make.height.equalTo(width * 9/16)
        }
    }
}

// MARK: - ViewCode
extension CardListScreen: ViewCode {
    
    func buildViewHierarchy() {
        addSubview(backgroundImageView)
        addSubview(listCollectionView)
        addSubview(searchBar)
        addSubview(activityIndicator)
    }
    
    func setupConstraints() {
        
        backgroundImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        listCollectionView.snp.makeConstraints { (make) in
            make.leading.trailing.bottomMargin.equalToSuperview()
            make.top.equalTo(searchBar.snp.bottom).offset(16)
        }
        
        searchBar.snp.makeConstraints { (make) in
            make.leadingMargin.equalToSuperview().offset(16)
            make.trailingMargin.equalToSuperview().inset(16)
            make.topMargin.equalToSuperview().offset(23)
            make.height.equalTo(30)
        }
        
        activityIndicator.snp.makeConstraints { (make) in
            make.centerWithinMargins.equalTo(listCollectionView.snp.centerWithinMargins)
            make.width.height.equalTo(100)
        }
    }
    
    func setupAdditionalConfiguration() {
        cardDataSource.registerCells(on: listCollectionView)
        listCollectionView.dataSource = cardDataSource
        listCollectionView.delegate = cardDelegate
    }
}

extension CardListScreen: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, text.trimmingCharacters(in: .whitespacesAndNewlines) != "" else {
            return
        }
        searchBar.endEditing(true)
        viewModel.didEnterSearchText(text)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.endEditing(true)
        viewModel.didCancelSearch()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
}
