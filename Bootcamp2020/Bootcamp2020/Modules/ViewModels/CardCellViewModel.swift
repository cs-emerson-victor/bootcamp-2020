//
//  CardCellViewModel.swift
//  Bootcamp2020
//
//  Created by jacqueline alves barbosa on 13/03/20.
//  Copyright © 2020 Team2. All rights reserved.
//

import UIKit

struct CardCellViewModel {
    
    let card: Card
    
    init(card: Card) {
        self.card = card
    }
}

extension CardCellViewModel {
    
    var image: UIImage? {
        guard let imageData = card.imageData else {
            return nil
        }
        
        return UIImage(data: imageData)
    }
}
