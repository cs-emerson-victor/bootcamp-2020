//
//  CardDetailDelegate.swift
//  Bootcamp2020
//
//  Created by jacqueline alves barbosa on 18/03/20.
//  Copyright © 2020 Team2. All rights reserved.
//

protocol ShowCardDetailDelegate: AnyObject {
    var saver: CardSaverProtocol { get }
    
    func show(_ cards: [Card], selectedCardId id: String)
}

extension ShowCardDetailDelegate where Self: Coordinator & DismissCardDetailDelegate {
    func show(_ cards: [Card], selectedCardId id: String) {
        let controller = CardDetailViewController(cards: cards, selectedCardId: id, service: saver, delegate: self)
        controller.modalPresentationStyle = .fullScreen
        rootController.present(controller, animated: true)
    }
}
