//
//  CardDetailDelegate.swift
//  Bootcamp2020
//
//  Created by jacqueline alves barbosa on 18/03/20.
//  Copyright © 2020 Team2. All rights reserved.
//

protocol ShowCardDetailDelegate: AnyObject {
    var saver: CardSaverProtocol { get }
    
    func show(_ cardSet: CardSet, selectedCardId id: String)
}

extension ShowCardDetailDelegate where Self: Coordinator & DismissCardDetailDelegate {
    func show(_ cardSet: CardSet, selectedCardId id: String) {
        let controller = CardDetailViewController(cardSet: cardSet, selectedCardId: id, service: saver, delegate: self)
        controller.modalPresentationStyle = .fullScreen
        rootController.present(controller, animated: true)
    }
}
