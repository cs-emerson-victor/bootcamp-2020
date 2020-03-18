//
//  CardListViewController.swift
//  Bootcamp2020
//
//  Created by jacqueline alves barbosa on 13/03/20.
//  Copyright © 2020 Team2. All rights reserved.
//

import UIKit

final class CardListViewController: UIViewController {

    // MARK: - Properties -
    private(set) var sets: [CardSet] = []
    
    private var listScreen: CardListScreen
    var service: Service
    
    // MARK: - Init -
    init(service: Service,
         screen: CardListScreen = CardListScreen()) {
        
        self.service = service
        self.listScreen = screen
        
        if listScreen.cardDataSource.getViewModel == nil {
//            listScreen.cardDataSource.getViewModel = { (indexPath) in
//                // TODO: Implement once ViewModel is made
//                return CardCellViewModel()
//            }
        }
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods -
    
    // MARK: Lifecycle
    override func loadView() {
        
        view = listScreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO: Loading initial state ViewModel
        service.fetchSets { [weak self] (result) in
            switch result {
            case .success(let cardSets):
                self?.sets.append(contentsOf: cardSets)
            // TODO: Error ViewModel
            case .failure(_):
                break
            }
        }
    }
}
