//
//  CardCellViewModelSpec.swift
//  Bootcamp2020Tests
//
//  Created by emerson.victor.f.luz on 18/03/20.
//  Copyright © 2020 Team2. All rights reserved.
//

@testable import Bootcamp2020
import Quick
import Nimble

final class CardCellViewModelSpec: QuickSpec {

    override func spec() {
        describe("CardCellViewModel") {
            var card: Card!
            var sut: CardCellViewModel!
            
            context("when it's initialized") {
                beforeEach {
                    card = Card(id: "0", name: "Card1", imageData: nil, cardSetID: "0")
                    sut = CardCellViewModel(card: card)
                }
                
                it("should have the given card") {
                    expect(sut.card).to(beIdenticalTo(card))
                }
            }
            
            context("when image is computed") {
                it("should return nil") {
                    card = Card(id: "0", name: "Card1", imageData: nil, cardSetID: "0")
                    sut = CardCellViewModel(card: card)
                    
                    expect(sut.imageURL).to(beNil())
                }
                
                it("should return the given url") {
                    let urlString = "http://gatherer.wizards.com/Handlers/Image.ashx?multiverseid=130483&type=card"
                    guard let url = URL(string: urlString) else {
                        Nimble.fail()
                        return
                    }
                    
                    card = Card(id: "0", name: "Card1", imageURL: urlString, cardSetID: "0")
                    sut = CardCellViewModel(card: card)
                    
                    expect(sut.imageURL).to(equal(url))
                }
            }
        }
    }
}
