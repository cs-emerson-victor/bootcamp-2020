//
//  CardListViewModel.swift
//  Bootcamp2020
//
//  Created by jacqueline alves barbosa on 13/03/20.
//  Copyright © 2020 Team2. All rights reserved.
//

import Foundation

protocol CardListViewModelDelegate: AnyObject {
    
    func didSet(_ state: CardListViewModel.UIState)
    func didSelect(_ card: Card)
    func prefetchSet(_ set: CardSet)
}

struct CardListViewModel {
    
    let state: UIState
    let cardSets: [CardSet]
    private(set) weak var delegate: CardListViewModelDelegate?
    
    init(state: UIState, delegate: CardListViewModelDelegate) {
        self.delegate = delegate
        self.state = state
        
        switch state {
        case .success(let cardSets):
            self.cardSets = cardSets
        case .loading(let cardSets):
            // TODO: Check this implementation
            self.cardSets = cardSets
        default:
            self.cardSets = []
        }
    }
}

extension CardListViewModel {
    enum UIState: Equatable {
        case initialLoading
        case loading([CardSet])
        case success([CardSet])
        case error
    }
    
    func cellViewModel(for indexPath: IndexPath) -> CardCellViewModel {
        let card = cardSets[indexPath.section].cards[indexPath.row]
        if indexPath.row == cardSets[indexPath.section].cards.count - 1,
            indexPath.section < cardSets.count - 1 {
            
            delegate?.prefetchSet(cardSets[indexPath.section + 1])
        }
        return CardCellViewModel(card: card)
    }
    
    func didSelectCell(at indexPath: IndexPath) {
        let card = cardSets[indexPath.section].cards[indexPath.row]
        delegate?.didSelect(card)
    }
}
