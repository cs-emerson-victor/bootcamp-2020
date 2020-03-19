//
//  CardDetailViewModelSpec.swift
//  Bootcamp2020Tests
//
//  Created by emerson.victor.f.luz on 18/03/20.
//  Copyright © 2020 Team2. All rights reserved.
//

@testable import Bootcamp2020
import Quick
import Nimble

final class CardDetailViewModelSpec: QuickSpec {
    override func spec() {
        describe("CardDetailViewModel") {
            var cards: [Card]!
            var delegate: CardDetailViewModelDelegateSpy!
            var sut: CardDetailViewModel!
            
            beforeEach {
                cards = [Card(id: "0", name: "Card1"),
                         Card(id: "1", name: "Card2", isFavorite: true)]
                delegate = CardDetailViewModelDelegateSpy()
                sut = CardDetailViewModel(cards: cards, delegate: delegate)
            }
            
            context("when it's initialized") {
                it("should have the given cards and delegate") {
                    expect(sut.cards).to(equal(cards))
                    expect(sut.delegate).to(beIdenticalTo(delegate))
                }
            }
            
            context("when CardCellViewModel it's created") {
                it("should return a viewModel with the correct card") {
                    let viewModel = sut.cellViewModel(for: IndexPath(row: 0, section: 0))
                    expect(viewModel.card).to(beIdenticalTo(cards[0]))
                }
            }
            
            context("when checked if card was favorited") {
                it("should return true") {
                    let isFavorite = sut.isCardFavorite(at: IndexPath(row: 1, section: 0))
                    expect(isFavorite).to(beTrue())
                }
                
                it("should return false") {
                    let isFavorite = sut.isCardFavorite(at: IndexPath(row: 0, section: 0))
                    expect(isFavorite).to(beFalse())
                }
            }
            
            context("when toggle card favorite") {
                it("should call delegate toggle function") {
                    sut.toggleCardFavorite(at: IndexPath(row: 0, section: 0))
                    
                    expect(delegate.toggleFunctionWasCalled).to(beTrue())
                    expect(delegate.card).to(beIdenticalTo(cards[0]))
                }
            }
            
            context("when dismiss card detail modal") {
                it("should call delegate dismiss function") {
                    sut.dismissDetail()
                    
                    expect(delegate.modalWasDismissed).to(beTrue())
                }
            }
        }
    }
}
