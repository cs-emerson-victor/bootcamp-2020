//
//  CardDetailViewControllerSpec.swift
//  Bootcamp2020Tests
//
//  Created by alexandre.c.ferreira on 18/03/20.
//  Copyright © 2020 Team2. All rights reserved.
//

import Quick
import Nimble
@testable import Bootcamp2020

final class CardDetailViewControllerSpec: QuickSpec {
    
    override func spec() {
        
        var sut: CardDetailViewController!
        var screen: CardDetailScreen!
        var service: LocalServiceDummy!
        var cards: [Card]!
        
        beforeEach {
            
            cards = CardSetStub().getCardsOfSet(CardSet(id: "id", name: "Set name"))
            screen = CardDetailScreen()
            service = LocalServiceDummy()
            sut = CardDetailViewController(cards: cards, selectedCardId: cards[2].id, service: service, screen: screen)
            
            _ = sut.view
        }
        
        afterEach {
            
            screen = nil
            service = nil
            sut = nil
            cards = nil
        }
        
        describe("CardDetailViewController") {
            context("when initialized") {
                it("should have the correct given objects") {
                    
                    expect(sut.view).to(beIdenticalTo(screen))
                    expect(sut.service).to(beIdenticalTo(service))
                    expect(sut.cards).to(equal(cards))
                }
                
                context("the view") {
                    it("should be of the correct type") {
                        
                        expect(sut.view).to(beAKindOf(CardDetailScreen.self))
                    }
                }
            }
        }
    }
}
