//
//  CardDetailViewController.swift
//  Bootcamp2020
//
//  Created by jacqueline alves barbosa on 13/03/20.
//  Copyright © 2020 Team2. All rights reserved.
//

import UIKit

final class CardDetailViewController: UIViewController {

    // MARK: - Properties -
    private(set) var cards: [Card] = []
    
    private var detailScreen: CardDetailScreen
    var service: Service
    
    // MARK: - Init -
    init(service: Service,
         screen: CardDetailScreen = CardDetailScreen()) {
        
        self.service = service
        self.detailScreen = screen
        
        if detailScreen.cardDetailDataSource.getViewModel == nil {
            detailScreen.cardDetailDataSource.getViewModel = { (indexPath) in
                // TODO: Implement once ViewModel is made
                return CardCellViewModel()
            }
        }
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods -
    
    // MARK: Lifecycle
    override func loadView() {
        view = detailScreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
