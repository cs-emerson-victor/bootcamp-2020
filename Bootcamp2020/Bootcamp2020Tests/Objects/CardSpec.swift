//
//  CardSpec.swift
//  Bootcamp2020Tests
//
//  Created by emerson.victor.f.luz on 17/03/20.
//  Copyright © 2020 Team2. All rights reserved.
//

@testable import Bootcamp2020
import Quick
import Nimble

final class CardSpec: QuickSpec {
    
    override func spec() {
        describe("Card") {
            var sut: Card!
            
            it("should have 'id' as primary key") {
                expect(Card.primaryKey()).to(equal("id"))
            }
            
            context("when it's initialized") {
                beforeEach {
                    sut = Card(id: "0",
                               name: "Card1",
                               imageURL: nil,
                               imageData: nil,
                               cardSetID: "0",
                               isFavorite: false, types: [])
                }
                
                it("should have the given values") {
                    expect(sut.id).to(equal("0"))
                    expect(sut.name).to(equal("Card1"))
                    expect(sut.imageURL).to(beNil())
                    expect(sut.imageData).to(beNil())
                    expect(sut.cardSetID).to(equal("0"))
                    expect(sut.isFavorite).to(beFalse())
                    expect(sut.types).to(beEmpty())
                }
            }
            
            context("when it's copied") {
                it("should return an object with the same values") {
                    let copy = sut.createCopy()
                    
                    expect(copy.id).to(equal(sut.id))
                    expect(copy.name).to(equal(sut.name))
                    expect(copy.imageURL).to(beNil())
                    expect(copy.imageData).to(beNil())
                    expect(copy.cardSetID).to(equal(sut.cardSetID))
                    expect(copy.isFavorite).to(equal(sut.isFavorite))
                    expect(Array(copy.types)).to(equal(Array(sut.types)))
                }
            }
        }
    }
}
