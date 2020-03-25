//
//  RealmCardSpec.swift
//  Bootcamp2020Tests
//
//  Created by emerson.victor.f.luz on 25/03/20.
//  Copyright © 2020 Team2. All rights reserved.
//

@testable import Bootcamp2020
import Quick
import Nimble

final class RealmCardSpec: QuickSpec {
    
    override func spec() {
        describe("RealmCard") {
            var sut: RealmCard!
            
            it("should have 'id' as primary key") {
                expect(RealmCard.primaryKey()).to(equal("id"))
            }
            
            context("when it's initialized") {
                beforeEach {
                    sut = RealmCard(card: Card(id: "0",
                                               name: "Card1",
                                               imageURL: nil,
                                               imageData: nil,
                                               cardSetID: "0",
                                               isFavorite: false,
                                               types: []))
                }
                
                it("should have the object values") {
                    expect(sut.id).to(equal("0"))
                    expect(sut.name).to(equal("Card1"))
                    expect(sut.imageURL).to(beNil())
                    expect(sut.imageData).to(beNil())
                    expect(sut.cardSetID).to(equal("0"))
                    expect(sut.types).to(beEmpty())
                }
            }
        }
    }
}
