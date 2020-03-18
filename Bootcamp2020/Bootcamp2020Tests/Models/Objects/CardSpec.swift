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
                    sut = Card(id: "0", name: "Card1", imageURL: nil, imageData: nil, isFavorite: false, types: [])
                }
                
                it("should have the given values") {
                    expect(sut.id).to(equal("0"))
                    expect(sut.name).to(equal("Card1"))
                    expect(sut.imageURL).to(beNil())
                    expect(sut.imageData).to(beNil())
                    expect(sut.isFavorite).to(beFalse())
                    expect(sut.types).to(beEmpty())
                }
            }
            
            context("when toggle favorite") {
                it("should have isFavorite property as true") {
                    sut = Card(id: "0", name: "Card1", isFavorite: false)
                    let isFavorite = sut.toggleFavorite()
                    
                    expect(isFavorite).to(beTrue())
                    expect(sut.isFavorite).to(beTrue())
                }
                
                it("should have isFavorite property as false") {
                    sut = Card(id: "0", name: "Card1", isFavorite: true)
                    let isFavorite = sut.toggleFavorite()
                    
                    expect(isFavorite).to(beFalse())
                    expect(sut.isFavorite).to(beFalse())
                }
            }
        }
    }
}
