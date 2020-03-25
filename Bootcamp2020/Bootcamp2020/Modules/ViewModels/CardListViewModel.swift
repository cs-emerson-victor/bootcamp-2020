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
    func didSelect(_ card: Card, of set: CardSet)
    func prefetchSet(_ set: CardSet)
    func didEnterSearchText(_ text: String)
    func didCancelSearch()
}

struct CardListViewModel {
    
    let state: UIState
    let cardSets: [CardSet]
    private(set) weak var delegate: CardListViewModelDelegate?
    
    private let loadedCardSets: [CardSet]
    
    let cellTypes: [[CellType]]
    
    init(state: UIState, delegate: CardListViewModelDelegate) {
        self.delegate = delegate
        self.state = state
        
        switch state {
        case .success(let cardSets), .searchSuccess(let cardSets), .loading(let cardSets):
            self.cardSets = cardSets
            self.loadedCardSets = cardSets.filter { !$0.cards.isEmpty }
        default:
            self.cardSets = []
            self.loadedCardSets = []
        }
        
        self.cellTypes = loadedCardSets.map { set -> [CellType] in
            var types: [CellType] = []
            
            set.types.forEach { type in
                types.append(.typeHeader(type))
                
                set.cardsByType[type]?.forEach({ card in
                    types.append(.card(CardCellViewModel(card: card)))
                })
            }
            
            return types
        }
    }
}

extension CardListViewModel {
    enum UIState: Equatable {
        case initialLoading
        case loading([CardSet])
        case success([CardSet])
        case searching
        case searchSuccess([CardSet])
        case error(_ type: ErrorType)
    }
    
    func cellType(for indexPath: IndexPath) -> CellType {
        return cellTypes[indexPath.section][indexPath.row]
    }
    
    func didSelectCell(at indexPath: IndexPath) {
        let set = loadedCardSets[indexPath.section]
        delegate?.didSelect(set.cards[indexPath.row], of: set)
    }
}

// MARK: - Search bar
extension CardListViewModel {
    func didEnterSearchText(_ text: String) {
        delegate?.didEnterSearchText(text)
    }
    
    func didCancelSearch() {
        delegate?.didCancelSearch()
    }
}

// MARK: - DataSourceProtocol
extension CardListViewModel: CardListDataSourceProtocol {
    var numberOfSections: Int {
        return loadedCardSets.count
    }
    
    func numberOfItems(in section: Int) -> Int {
        let cardsForType = loadedCardSets[section].cardsByType.values.reduce(0) { (count, cards) -> Int in
            return count + cards.count
        }
        return loadedCardSets[section].types.count + cardsForType
    }
    
    func getCellTypeForDataSource(forItemAt indexPath: IndexPath) -> CellType {
        let type = cellType(for: indexPath)
        if case .success = state {
            if indexPath.row == cardSets[indexPath.section].cards.count - 1,
                indexPath.section < cardSets.count - 1 {
                
                delegate?.prefetchSet(cardSets[indexPath.section + 1])
            }
        }
        return type
    }
    
    func getSetHeaderName(in section: Int) -> String {
        return loadedCardSets[section].name
    }
}
