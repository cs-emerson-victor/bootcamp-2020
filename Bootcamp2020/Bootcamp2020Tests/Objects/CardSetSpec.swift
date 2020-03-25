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
            }
            
            context("when it's initialized") {
                it("should have the given values") {
                    sut = CardSet(id: "0", name: "Set1", releaseDate: date, cards: [])
                    
                    expect(sut.id).to(equal("0"))
                    expect(sut.name).to(equal("Set1"))
                    expect(sut.releaseDate).to(equal(date))
                    expect(sut.cards).to(beEmpty())
                }
                
                it("should have the object values") {
                    let realmSet = RealmCardSet()
                    realmSet.id = "0"
                    realmSet.name = "Set1"
                    realmSet.releaseDate = date
                    
                    sut = CardSet(set: realmSet)
                    
                    expect(sut.id).to(equal("0"))
                    expect(sut.name).to(equal("Set1"))
                    expect(sut.releaseDate).to(equal(date))
                    expect(sut.cards).to(beEmpty())
                }
            }
            
            context("when it's loaded card for each type") {
                var cards: [Card]!
                
                beforeEach {
                    cards = [
                        Card(id: "", name: "c", cardSetID: "", isFavorite: false, types: ["type1", "type2"]),
                        Card(id: "", name: "be", cardSetID: "", isFavorite: false, types: ["type1"]),
                        Card(id: "", name: "a", cardSetID: "", isFavorite: false, types: ["type3"]),
                        Card(id: "", name: "ab", cardSetID: "", isFavorite: false, types: ["type2", "type3"])
                    ]
                    
                    sut = CardSet(id: "", name: "", releaseDate: date, cards: cards)
                }
                
                it("should have the correct dictionary") {
                    let cardsByType: [String: [Card]] = [
                        "type1": [cards[1], cards[0]],
                        "type2": [cards[3], cards[0]],
                        "type3": [cards[2], cards[3]]
                    ]
                    
                    expect(sut.cardsByType).to(equal(cardsByType))
                }
            }
        }
    }
}
