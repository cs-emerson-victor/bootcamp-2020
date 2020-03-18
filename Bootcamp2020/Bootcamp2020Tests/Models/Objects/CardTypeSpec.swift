//
//  CardTypeSpec.swift
//  Bootcamp2020Tests
//
//  Created by emerson.victor.f.luz on 17/03/20.
//  Copyright © 2020 Team2. All rights reserved.
//

@testable import Bootcamp2020
import Quick
import Nimble

final class CardTypeSpec: QuickSpec {
    
    override func spec() {
        describe("CardType") {
            var sut: CardType!
            
            beforeEach {
                sut = CardType(name: "Type1")
            }
            
            it("should have 'name' as primary key") {
                expect(CardType.primaryKey()).to(equal("name"))
            }
            
            context("when it's initialized") {
                it("should have the given values") {
                    expect(sut.name).to(equal("Type1"))
                }
            }
        }
    }
}
