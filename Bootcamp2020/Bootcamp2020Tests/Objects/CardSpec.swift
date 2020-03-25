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
            
            context("when it's initialized") {
                it("should have the given values") {
                    sut = Card(id: "0",
                               name: "Card1",
                               imageURL: nil,
                               imageData: nil,
                               cardSetID: "0",
                               isFavorite: false,
                               types: [])
                    
                    expect(sut.id).to(equal("0"))
                    expect(sut.name).to(equal("Card1"))
                    expect(sut.imageURL).to(beNil())
                    expect(sut.imageData).to(beNil())
                    expect(sut.cardSetID).to(equal("0"))
                    expect(sut.isFavorite).to(beFalse())
                    expect(sut.types).to(beEmpty())
                }
                
                it("should have the object values") {
                    let realmCard = RealmCard()
                    realmCard.id = "0"
                    realmCard.name = "Card1"
                    realmCard.imageURL = nil
                    realmCard.imageData = nil
                    realmCard.cardSetID = "0"
                    
                    sut = Card(card: realmCard)
                    
                    expect(sut.id).to(equal("0"))
                    expect(sut.name).to(equal("Card1"))
                    expect(sut.imageURL).to(beNil())
                    expect(sut.imageData).to(beNil())
                    expect(sut.cardSetID).to(equal("0"))
                    expect(sut.isFavorite).to(beTrue())
                    expect(sut.types).to(beEmpty())
                }
            }
        }
    }
}
