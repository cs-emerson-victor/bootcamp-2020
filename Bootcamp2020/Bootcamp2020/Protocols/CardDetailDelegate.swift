//
//  CardDetailDelegate.swift
//  Bootcamp2020
//
//  Created by jacqueline alves barbosa on 18/03/20.
//  Copyright © 2020 Team2. All rights reserved.
//

protocol CardDetailDelegate: AnyObject {
    var localService: CardSaverProtocol { get set }
    
    func show(_ cards: [Card], scrollingToId id: String)
}

extension CardDetailDelegate where Self: Coordinator & CardSaverProtocol {
    func show(_ cards: [Card], scrollingToId id: String) {
        let controller = CardDetailViewController(service: localService, cards: cards, cardId: id)
        rootController.pushViewController(controller, animated: true)
    }
}
