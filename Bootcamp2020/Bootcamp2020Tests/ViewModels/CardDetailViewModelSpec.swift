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
                cards = [Card(id: "0", name: "Card1", cardSetID: "0"),
                         Card(id: "1", name: "Card2", cardSetID: "0", isFavorite: true)]
                delegate = CardDetailViewModelDelegateSpy()
                sut = CardDetailViewModel(cards: cards, selectedCardId: cards[1].id, delegate: delegate)
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
            
            context("when checked if card it's favorite") {
                it("should return true") {
                    let isFavorite = sut.isCardFavorite(at: IndexPath(row: 1, section: 0))
                    expect(isFavorite).to(beTrue())
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
            
            context("when asked for fisrt selected index path") {
                it("should return the index path accoding to the card id") {
                    expect(sut.firstSelectedIndexPath).to(equal(IndexPath(item: 1, section: 0)))
                }
            }
        }
    }
}
