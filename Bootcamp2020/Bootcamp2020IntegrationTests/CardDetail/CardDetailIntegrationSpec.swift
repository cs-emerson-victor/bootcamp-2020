//
//  CardDetailIntegrationSpec.swift
//  Bootcamp2020Tests
//
//  Created by alexandre.c.ferreira on 18/03/20.
//  Copyright © 2020 Team2. All rights reserved.
//

import Quick
import Nimble
import KIF
@testable import Bootcamp2020

class CardDetailIntegrationSpec: QuickSpec {
    
    override func spec() {
        
        var viewController: CardDetailViewController!
        var screen: CardDetailScreen!
        var service: LocalServiceDummy!
        var dataSource: CardDetailDataSource!
        var delegate: CardDetailDelegate!
        var dismissDelegate: DismissCardDetailDelegateSpy!
        var window: UIWindow!
        var cards: [Card]!
        
        beforeEach {
            
            cards = CardSetStub().getCardsOfSet(CardSet(id: "id", name: "Set name"))
            service = LocalServiceDummy()
            dataSource = CardDetailDataSource()
            delegate = CardDetailDelegate()
            dismissDelegate = DismissCardDetailDelegateSpy()
            screen = CardDetailScreen(dataSource: dataSource, delegate: delegate)
            viewController = CardDetailViewController(cards: cards,
                                                      selectedCardId: cards[2].id,
                                                      service: service,
                                                      delegate: dismissDelegate,
                                                      screen: screen)
            window = UIWindow(frame: UIScreen.main.bounds)
            
            window.rootViewController = viewController
            window.makeKeyAndVisible()
            _ = viewController.view
        }
        
        afterEach {
            service = nil
            dataSource = nil
            screen = nil
            viewController = nil
            window = nil
            cards = nil
        }
        
        describe("CardDetail") {
            context("when loaded") {
                it("should display the correct views") {
                    self.tester.waitForView(withAccessibilityLabel: "cardDetailCollectionView")
                    self.tester.waitForView(withAccessibilityLabel: "CardDetailScreen")
                    self.tester.waitForView(withAccessibilityLabel: "detailBackgroundImageView")
                    self.tester.waitForView(withAccessibilityLabel: "closeButton")
                    self.tester.waitForView(withAccessibilityLabel: "favoriteButton")
                }
            }
        }
    }
}