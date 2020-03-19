//
//  CardListViewControllerSpec.swift
//  Bootcamp2020Tests
//
//  Created by alexandre.c.ferreira on 17/03/20.
//  Copyright © 2020 Team2. All rights reserved.
//

import Quick
import Nimble
import  RealmSwift
@testable import Bootcamp2020

final class CardListViewControllerSpec: QuickSpec {
    
    override func spec() {
        
        var sut: CardListViewController!
        var screen: CardListScreen!
        var service: NetworkServiceStub!
        
        beforeEach {
            
            screen = CardListScreen()
            service = NetworkServiceStub()
            sut = CardListViewController(service: service, screen: screen)
            
            _ = sut.view
        }
        
        afterEach {
            
            screen = nil
            service = nil
            sut = nil
        }
        
        describe("CardListViewController") {
            context("when initialized") {
                it("should have the correct given objects") {
                    
                    expect(sut.view).to(beIdenticalTo(screen))
                    expect(sut.service).to(beIdenticalTo(service))
                }
                
                context("the view") {
                    it("should be of the correct type") {
                        
                        expect(sut.view).to(beAKindOf(CardListScreen.self))
                    }
                }
            }
            
            context("after loading view") {
                it("should fetch initially") {
                    
                    expect(sut.sets).to(equal(service.fetchedSets))
                }
            }
            
            context("when fetching cards for set") {
                var set: CardSet!
                var cards: List<Card>!
                
                beforeEach {
                    set = service.fetchedSets[0]
                    cards = set.cards
                    set.cards.removeAll()
                    sut.fetchCardsForSet(set)
                }
                
                it("should add the correct cards to set") {
                    expect(set.cards).to(equal(cards))
                }
            }
        }
    }
}
