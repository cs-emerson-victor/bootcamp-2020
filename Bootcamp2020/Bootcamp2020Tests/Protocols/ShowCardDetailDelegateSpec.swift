//
//  ShowCardDetailDelegateSpec.swift
//  Bootcamp2020Tests
//
//  Created by emerson.victor.f.luz on 24/03/20.
//  Copyright © 2020 Team2. All rights reserved.
//

@testable import Bootcamp2020
import Quick
import Nimble

final class ShowCardDetailDelegateSpec: QuickSpec {
    
    override func spec() {
        describe("ShowCardDetailDelegate") {
        
            var cardSet: CardSet!
            var navigationControllerSpy: UINavigationControllerSpy!
            var sut: ShowCardDetailDelegate!
            
            beforeEach {
                cardSet = CardSetStub().getFullSets()[0]
                navigationControllerSpy = UINavigationControllerSpy()
                sut = CoordinatorSpy(rootController: navigationControllerSpy)
            }
            
            context("when card detail it's showed") {
                it("should show card detail") {
                    sut.show(cardSet, selectedCardId: cardSet.cards[0].id)
                    
                    expect(navigationControllerSpy.showWasCalled).to(beTrue())
                }
            }
            
        }
    }
}
