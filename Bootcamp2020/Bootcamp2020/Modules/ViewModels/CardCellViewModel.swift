//
//  CardCellViewModel.swift
//  Bootcamp2020
//
//  Created by jacqueline alves barbosa on 13/03/20.
//  Copyright © 2020 Team2. All rights reserved.
//

import UIKit

struct CardCellViewModel {
    
    let image: UIImage?
    
    init(card: Card) {
        guard let imageData = card.imageData else {
            image = nil
            return
        }
        
        image = UIImage(data: imageData)
    }
}
