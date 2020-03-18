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
                    card = Card(id: "0", name: "Card1", imageData: nil)
                    sut = CardCellViewModel(card: card)
                }
                
                it("should have the given card") {
                    expect(sut.card).to(beIdenticalTo(card))
                }
            }
            
            context("when image is computed") {
                it("should return nil") {
                    card = Card(id: "0", name: "Card1", imageData: nil)
                    sut = CardCellViewModel(card: card)
                    
                    expect(sut.image).to(beNil())
                }
                
                it("should return the given image") {
                    let image = UIImage(named: "card", in: Bundle(for: CardCellViewModelSpec.self), compatibleWith: nil)
                    guard let imageData = image?.pngData() else {
                        Nimble.fail()
                        return
                    }
                    
                    card = Card(id: "0", name: "Card1", imageData: imageData)
                    sut = CardCellViewModel(card: card)
                    
                    expect(sut.image).to(beAnInstanceOf(UIImage.self))
                    
                }
                
            }
        }
    }
}
