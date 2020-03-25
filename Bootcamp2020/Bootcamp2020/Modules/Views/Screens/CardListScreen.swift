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
        view.placeholder = "Search for cards"
        view.searchTextField.backgroundColor = UIColor(white: 0.15, alpha: 1)
        view.searchTextField.textColor = .white
        if let searchIcon = view.searchTextField.leftView as? UIImageView {
            searchIcon.image = searchIcon.image?.withRenderingMode(.alwaysTemplate)
            searchIcon.tintColor = .gray
        }
        view.isTranslucent = true
        view.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        view.tintColor = UIColor(red: 0.92, green: 0.60, blue: 0.18, alpha: 1.00)
        view.delegate = self
        return view
    }()
    
    private let backgroundImageView: UIView = {
        let view = UIView(frame: .zero)
        view.accessibilityLabel = "backgroundImageView"
        view.backgroundColor = UIColor(red: 0.05, green: 0.05, blue: 0.05, alpha: 1.00)

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
    
    var isInitialLoading: Bool {
        guard viewModel != nil else { return false }
        switch viewModel.state {
        case .initialLoading:
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
        
        cardDataSource.dataSourceProtocol = viewModel
        cardDelegate.didSelectItemAt = viewModel.didSelectCell
        cardDelegate.didScroll = { [weak self] in
            self?.searchBar.endEditing(true)
        }
        
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
        case .error(let type):
            DispatchQueue.main.async { [weak self] in
                self?.displayError(type: type)
                self?.activityIndicator.stopAnimating()
            }
        case .loading:
            DispatchQueue.main.async { [weak self] in
                self?.activityIndicator.startAnimating()
                self?.hideError()
            }
        }
        
        remakeActivityIndicationConstraints()
    }
    
    // MARK: Error handling
    private func displayError(type: ErrorType) {
        errorView.display(type: type)
        
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
    
    private func remakeActivityIndicationConstraints() {
        switch viewModel.state {
        case .initialLoading, .searching:
            DispatchQueue.main.async {
                self.activityIndicator.snp.remakeConstraints { (make) in
                    make.top.equalTo(self.searchBar.snp.bottom).offset(8)
                    make.bottom.right.left.equalToSuperview()
                }
            }
        case .loading:
            DispatchQueue.main.async {
                self.activityIndicator.snp.remakeConstraints { (make) in
                    make.bottom.right.left.equalToSuperview()
                    make.height.equalTo(60)
                }
            }
        default:
            DispatchQueue.main.async {
                self.activityIndicator.snp.remakeConstraints { (make) in
                    make.bottom.right.left.equalToSuperview()
                    make.height.equalTo(0)
                }
            }
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
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(searchBar.snp.bottom).offset(8)
            make.bottom.equalTo(activityIndicator.snp.top)
        }
        
        searchBar.snp.makeConstraints { (make) in
            make.leadingMargin.equalToSuperview()
            make.trailingMargin.equalToSuperview()
            make.topMargin.equalToSuperview().offset(23)
            make.height.equalTo(40)
        }
        
        activityIndicator.snp.makeConstraints { (make) in
            make.top.equalTo(searchBar.snp.bottom).offset(8)
            make.bottom.right.left.equalToSuperview()
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
