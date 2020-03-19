//
//  CardDetailViewModel.swift
//  Bootcamp2020
//
//  Created by jacqueline alves barbosa on 13/03/20.
//  Copyright © 2020 Team2. All rights reserved.
//

import UIKit

protocol CardDetailViewModelDelegate: AnyObject {
    
    func toggleFavorite(_ card: Card)
    func dismissDetail(animated: Bool)
}

struct CardDetailViewModel {
    
    let cards: [Card]
    private(set) weak var delegate: CardDetailViewModelDelegate?
    
    init(cards: [Card], delegate: CardDetailViewModelDelegate) {
        self.cards = cards
        self.delegate = delegate
    }
}

extension CardDetailViewModel {
    func cellViewModel(for indexPath: IndexPath) -> CardCellViewModel {
        let card = cards[indexPath.row]
        return CardCellViewModel(card: card)
    }
    
    func isCardFavorite(at indexPath: IndexPath) -> Bool {
        let card = cards[indexPath.row]
        return card.isFavorite
    }
    
    func toggleCardFavorite(at indexPath: IndexPath) {
        let card = cards[indexPath.row]
        delegate?.toggleFavorite(card)
    }
    
    func dismissDetail(animated: Bool = true) {
        delegate?.dismissDetail(animated: animated)
    }
}
