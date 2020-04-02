//
//  CardCellViewModel.swift
//  Bootcamp2020
//
//  Created by jacqueline alves barbosa on 13/03/20.
//  Copyright © 2020 Team2. All rights reserved.
//

import Foundation

struct CardCellViewModel {
    
    let card: Card
    
    init(card: Card) {
        self.card = card
    }
}

extension CardCellViewModel {
    
    var imageURL: URL? {
        guard let imageURLString = card.imageURL else { return nil }
        guard let imageURL = URL(string: imageURLString) else {
            return nil
        }
        
        return imageURL
    }
}
