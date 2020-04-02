//
//  CardListViewModelDelegateDummy.swift
//  Bootcamp2020Tests
//
//  Created by alexandre.c.ferreira on 19/03/20.
//  Copyright © 2020 Team2. All rights reserved.
//

@testable import Bootcamp2020

final class CardListViewModelDelegateDummy: CardListViewModelDelegate {
    func didSelect(_ card: Card, of set: CardSet) {
        
    }
    
    func didSet(_ state: CardListViewModel.UIState) {
        
    }
    
    func prefetchSet(_ set: CardSet) {
        
    }
    
    func didEnterSearchText(_ text: String) {
        
    }
    
    func didCancelSearch() {
        
    }
}
