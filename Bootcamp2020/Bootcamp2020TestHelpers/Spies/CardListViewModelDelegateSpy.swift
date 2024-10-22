//
//  CardListViewModelDelegateSpy.swift
//  Bootcamp2020Tests
//
//  Created by emerson.victor.f.luz on 18/03/20.
//  Copyright © 2020 Team2. All rights reserved.
//

@testable import Bootcamp2020
import Foundation

final class CardListViewModelDelegateSpy: CardListViewModelDelegate {
    
    private(set) var didSelectCard: Bool = false
    private(set) var selectedCard: Card?
    private(set) var didBeginSearch: Bool = false
    private(set) var searchedText: String?
    private(set) var canceledSearch: Bool = false
    
    func didSet(_ state: CardListViewModel.UIState) { }
    
    func didSelect(_ card: Card, of set: CardSet) {
        didSelectCard = true
        selectedCard = card
    }
    
    func prefetchSet(_ set: CardSet) {
        
    }
    
    func didEnterSearchText(_ text: String) {
        didBeginSearch = true
        searchedText = text
    }
    
    func didCancelSearch() {
        canceledSearch = true
    }
}
