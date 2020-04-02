//
//  CardDetailViewControllerSpec.swift
//  Bootcamp2020Tests
//
//  Created by alexandre.c.ferreira on 18/03/20.
//  Copyright © 2020 Team2. All rights reserved.
//
// swiftlint:disable function_body_length

import Quick
import Nimble
@testable import Bootcamp2020

final class CardDetailViewControllerSpec: QuickSpec {
    
    override func spec() {

        var sut: CardDetailViewController!
        var cardSet: CardSet!
        var service: CardSaverSpy!
        var screen: CardDetailScreenSpy!
        var delegate: DismissCardDetailDelegateSpy!
        
        beforeEach {
            cardSet = CardSetStub().getFullSets()[0]
            screen = CardDetailScreenSpy()
            service = CardSaverSpy()
            delegate = DismissCardDetailDelegateSpy()
            sut = CardDetailViewController(cardSet: cardSet,
                                           selectedCardId: cardSet.cards[2].id,
                                           service: service,
                                           delegate: delegate,
                                           screen: screen)
            
            _ = sut.view
        }
        
        afterEach {
            
            screen = nil
            service = nil
            sut = nil
            cardSet = nil
        }
        
        describe("CardDetailViewController") {
            context("when initialized") {
                it("should have the correct given objects") {
                    
                    expect(sut.view).to(beIdenticalTo(screen))
                    expect(sut.service).to(beIdenticalTo(service))
                    expect(sut.cardSet).to(equal(cardSet))
                    expect(sut.delegate).to(beIdenticalTo(delegate))
                    expect(screen.countBind).to(equal(1))
                }
                
                context("the view") {
                    it("should be of the correct type") {
                        expect(sut.view).to(beAKindOf(CardDetailScreen.self))
                    }
                    
                    it("should have a light status bar") {
                        expect(sut.preferredStatusBarStyle).to(equal(.lightContent))
                    }
                }
            }
            
            context("when card it's favorited") {
                it("should save card and bind new view model") {
                    let card = cardSet.cards[0]
                    sut.toggleFavorite(card)
                    
                    expect(screen.countBind).to(equal(2))
                    expect(service.cardWasSaved).to(beTrue())
                }
            }
            
            context("when card detail it's dismissed") {
                it("should call delegate") {
                    sut.dismissDetail(animated: true)
                    
                    expect(delegate.modalWasDismissed).to(beTrue())
                }
            }
            
            context("when checked if card it's favorite") {
                it("should call service") {
                    _ = sut.isFavorite(cardSet.cards[0])
                    
                    expect(service.checkCardFavorite).to(beTrue())
                }
            }
        }
    }
}
