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
    var selectedCardId: String
    
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
        self.selectedCardId = selectedCardId

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
        
        detailScreen.bind(to: CardDetailViewModel(cards: Array(cardSet.cards), selectedCardId: selectedCardId, delegate: self))
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
          return .lightContent
    }
    
    // MARK: Show favorite error
    func showFavoriteError() {
        let alert = UIAlertController(title: "We couldn't favorite this card. Please try again.",
                                      message: nil,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
        
    }
}

// MARK: - View model delegate -
extension CardDetailViewController: CardDetailViewModelDelegate {
    
    func toggleFavorite(_ card: Card) {
        guard service.toggleFavorite(card, of: cardSet) != nil else {
            detailScreen.bind(to: CardDetailViewModel(cards: Array(cardSet.cards),
                                                      selectedCardId: selectedCardId, delegate: self))
            return
        }

        showFavoriteError()
    }
    
    func isFavorite(_ card: Card) -> Bool {
        return service.isFavorite(card)
    }
    
    func dismissDetail(animated: Bool = true) {
        delegate?.dismissDetail(animated: animated)
    }
}
