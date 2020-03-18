//
//  CardSetStub.swift
//  Bootcamp2020Tests
//
//  Created by alexandre.c.ferreira on 17/03/20.
//  Copyright © 2020 Team2. All rights reserved.
//

import Foundation
@testable import Bootcamp2020

final class CardSetStub {
    
    func getEmptySets() -> [CardSet] {
        
        var cardSets = [CardSet]()
        for index in 0...10 {
            cardSets.append(CardSet(id: "\(index)", name: "Set \(index)", releaseDate: Date() - 100*TimeInterval(index), cards: []))
        }
        return cardSets
    }
    
    func getFullSets() -> [CardSet] {
        
        var cardSets = [CardSet]()
        for setIndex in 0...10 {
            var cards = [Card]()
            for cardIndex in 0...5 {
                cards.append(Card(id: "\(setIndex)\(cardIndex)", name: "Card \(cardIndex) of set \(setIndex)"))
            }
            let set = CardSet(id: "\(setIndex)", name: "Set \(setIndex)", releaseDate: Date() - 100*TimeInterval(setIndex), cards: cards)
            cardSets.append(set)
        }
        return cardSets
    }
    
    func getCardsOfSet(_ set: CardSet) -> [Card] {
        
        var cards = [Card]()
        for cardIndex in 0...5 {
            cards.append(Card(id: "\(set.id)\(cardIndex)", name: "Card \(cardIndex) of set \(set.id)"))
        }
        return cards
    }
}
