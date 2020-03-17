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

class CardSpec: QuickSpec {
    
    override func spec() {
        describe("Card") {
            var sut: Card!
            
            beforeEach {
                sut = Card(id: "0", name: "Card1", imageURL: nil, imageData: nil, types: [])
            }
            
            it("should have 'id' as primary key") {
                expect(CardType.primaryKey()).to(equal("id"))
            }
            
            context("when it's initialized") {
                it("should have the given values") {
                    expect(sut.id).to(equal("0"))
                    expect(sut.name).to(equal("Card1"))
                    expect(sut.imageURL).to(beNil())
                    expect(sut.imageData).to(beNil())
                    expect(sut.types).to(beEmpty())
                }
            }
        }
    }
}
