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
    private(set) var cardSet: CardSet
    private var detailScreen: CardDetailScreen
    weak var delegate: DismissCardDetailDelegate?
    var service: CardSaverProtocol
    
    // MARK: - Init -
    init(cardSet: CardSet,
         selectedCardId: String,
         service: CardSaverProtocol,
         delegate: DismissCardDetailDelegate,
         screen: CardDetailScreen = CardDetailScreen()) {
        
        self.cardSet = cardSet
        self.service = service
        self.delegate = delegate
        self.detailScreen = screen

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
        
        detailScreen.bind(to: CardDetailViewModel(cards: Array(cardSet.cards), delegate: self))
    }
}

// MARK: - View model delegate -
extension CardDetailViewController: CardDetailViewModelDelegate {
    
    func toggleFavorite(_ card: Card) {
        _ = service.toggleFavorite(card, of: cardSet)
        
        // TODO: Handle favorite error
        
        detailScreen.bind(to: CardDetailViewModel(cards: Array(cardSet.cards), delegate: self))
    }
    
    func dismissDetail(animated: Bool = true) {
        delegate?.dismissDetail(animated: animated)
    }
}
