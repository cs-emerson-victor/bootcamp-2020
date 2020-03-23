//
//  CardSetSpec.swift
//  Bootcamp2020Tests
//
//  Created by emerson.victor.f.luz on 17/03/20.
//  Copyright © 2020 Team2. All rights reserved.
//

@testable import Bootcamp2020
import Quick
import Nimble

final class CardSetSpec: QuickSpec {
    
    override func spec() {
        describe("CardSet") {
            var date: Date!
            var sut: CardSet!
            
            beforeEach {
                date = Date()
                sut = CardSet(id: "0", name: "Set1", releaseDate: date, cards: [])
            }
            
            it("should have 'id' as primary key") {
                expect(CardSet.primaryKey()).to(equal("id"))
            }
            
            context("when it's initialized") {
                it("should have the given values") {
                    expect(sut.id).to(equal("0"))
                    expect(sut.name).to(equal("Set1"))
                    expect(sut.releaseDate).to(equal(date))
                    expect(sut.cards).to(beEmpty())
                }
            }
            
            context("when it's copied") {
                it("should return an object with the same values") {
                    let copy = sut.createCopy()
                    
                    expect(copy.id).to(equal(sut.id))
                    expect(copy.name).to(equal(sut.name))
                    expect(copy.releaseDate).to(equal(sut.releaseDate))
                    expect(copy.cards).to(beEmpty())
                }
            }
        }
    }
}
