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
        default:
            self.cardSets = []
        }
    }
}

extension CardListViewModel {
    enum UIState {
        case initialLoading
        case loading
        case success([CardSet])
        case error
    }
    
    func cellViewModel(for indexPath: IndexPath) -> CardCellViewModel {
        let card = cardSets[indexPath.section].cards[indexPath.row]
        return CardCellViewModel(card: card)
    }
    
    func didSelectCell(at indexPath: IndexPath) {
        let card = cardSets[indexPath.section].cards[indexPath.row]
        delegate?.didSelect(card)
    }
}
