//
//  CardDetailIntegrationSpec.swift
//  Bootcamp2020Tests
//
//  Created by alexandre.c.ferreira on 18/03/20.
//  Copyright © 2020 Team2. All rights reserved.
//
//swiftlint:disable force_cast function_body_length

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
        var cardSet: CardSet!
        
        beforeEach {
            cardSet = CardSetStub().getFullSets()[0]
            cardSet.cards[2].isFavorite = true
            service = LocalServiceDummy()
            dataSource = CardDetailDataSource()
            delegate = CardDetailDelegate()
            dismissDelegate = DismissCardDetailDelegateSpy()
            screen = CardDetailScreen(dataSource: dataSource, delegate: delegate)
            viewController = CardDetailViewController(cardSet: cardSet,
                                                      selectedCardId: cardSet.cards[2].id,
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
            cardSet = nil
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
                
                it("should display the selected card cell") {
                    self.tester.waitForAnimationsToFinish()
                    self.tester.waitForCell(at: IndexPath(item: 2, section: 0), inCollectionViewWithAccessibilityIdentifier: "cardDetailCollectionView")
                }
            }
            
            context("favorite button") {
                it("should display remove card from favorites") {
                    let favoriteButton = self.tester.waitForView(withAccessibilityLabel: "favoriteButton") as! FavoriteButton
                    expect(favoriteButton.title(for: .normal)).toNot(beNil())
                    expect(favoriteButton.title(for: .normal)).to(equal("remove card from favorites"))
                }
                
//                it("should display add card to favorites") {
//                    let favoriteButton = self.tester.waitForView(withAccessibilityLabel: "favoriteButton") as! FavoriteButton
//                    self.tester.waitForCell(at: IndexPath(item: 0, section: 0), inCollectionViewWithAccessibilityIdentifier: "cardDetailCollectionView")
//                    self.tester.waitForAnimationsToFinish()
//                    expect(favoriteButton.title(for: .normal)).toNot(beNil())
//                    expect(favoriteButton.title(for: .normal)).to(equal("add card to favorites"))
//                }
            }
        }
    }
}
