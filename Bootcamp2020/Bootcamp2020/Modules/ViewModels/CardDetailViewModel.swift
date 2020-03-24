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
    func isFavorite(_ card: Card) -> Bool
    func dismissDetail(animated: Bool)
}

struct CardDetailViewModel {
    
    let cards: [Card]
    private let selectedCardId: String
    private(set) weak var delegate: CardDetailViewModelDelegate?
    
    init(cards: [Card], selectedCardId: String, delegate: CardDetailViewModelDelegate) {
        self.cards = cards
        self.delegate = delegate
        self.selectedCardId = selectedCardId
    }
}

extension CardDetailViewModel {
    func cellViewModel(for indexPath: IndexPath) -> CardCellViewModel {
        let card = cards[indexPath.row]
        return CardCellViewModel(card: card)
    }
    
    func isCardFavorite(at indexPath: IndexPath) -> Bool {
        let card = cards[indexPath.row]
        guard let isFavorite = delegate?.isFavorite(card) else {
            return false
        }
        
        return isFavorite
    }
    
    func toggleCardFavorite(at indexPath: IndexPath) {
        let card = cards[indexPath.row]
        card.isFavorite = !card.isFavorite
        delegate?.toggleFavorite(card)
    }
    
    func dismissDetail(animated: Bool = true) {
        delegate?.dismissDetail(animated: animated)
    }
    
    var firstSelectedIndexPath: IndexPath {
        guard let selectedIndex = cards.firstIndex(where: { $0.id == selectedCardId }) else {
            return IndexPath(item: 0, section: 0)
        }
        return IndexPath(item: selectedIndex, section: 0)
    }
}
