//
//  RealmCardSetSpec.swift
//  Bootcamp2020Tests
//
//  Created by emerson.victor.f.luz on 25/03/20.
//  Copyright © 2020 Team2. All rights reserved.
//

@testable import Bootcamp2020
import Quick
import Nimble

final class RealmCardSetSpec: QuickSpec {
    
    override func spec() {
        describe("RealmCardSet") {
            var date: Date!
            var sut: RealmCardSet!
            
            it("should have 'id' as primary key") {
                expect(RealmCardSet.primaryKey()).to(equal("id"))
            }
            
            context("when it's initialized") {
                beforeEach {
                    date = Date()
                    sut = RealmCardSet(set: CardSet(id: "0", name: "Set1", releaseDate: date, cards: []))
                }
                
                it("should have the object values") {
                    expect(sut.id).to(equal("0"))
                    expect(sut.name).to(equal("Set1"))
                    expect(sut.releaseDate).to(equal(date))
                    expect(sut.cards).to(beEmpty())
                }
            }
        }
    }
}


