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
        
        beforeEach {
            
            screen = CardDetailScreen()
            service = LocalServiceDummy()
            sut = CardDetailViewController(service: service, screen: screen)
            
            _ = sut.view
        }
        
        afterEach {
            
            screen = nil
            service = nil
            sut = nil
        }
        
        describe("CardDetailViewController") {
            context("when initialized") {
                it("should have the correct given objects") {
                    
                    expect(sut.view).to(beIdenticalTo(screen))
                    expect(sut.service).to(beIdenticalTo(service))
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
