//
//  CardDetailViewModelDelegateDummy.swift
//  Bootcamp2020Tests
//
//  Created by alexandre.c.ferreira on 19/03/20.
//  Copyright © 2020 Team2. All rights reserved.
//

@testable import Bootcamp2020

final class CardDetailViewModelDelegateDummy: CardDetailViewModelDelegate {
    func isFavorite(_ card: Card) -> Bool {
        return false
    }
    
    func dismissDetail(animated: Bool) {
        
    }
    
    func toggleFavorite(_ card: Card) {
        
    }
}
