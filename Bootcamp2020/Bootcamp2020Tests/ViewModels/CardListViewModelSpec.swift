//
//  CardListViewModelSpec.swift
//  Bootcamp2020Tests
//
//  Created by emerson.victor.f.luz on 18/03/20.
//  Copyright © 2020 Team2. All rights reserved.
//

@testable import Bootcamp2020
import Quick
import Nimble

final class CardListViewModelSpec: QuickSpec {
    override func spec() {
        describe("CardListViewModel") {
            var delegate: CardListViewModelDelegateSpy!
            var cards: [Card]!
            var cardSets: [CardSet]!
            var sut: CardListViewModel!
            
            beforeEach {
                delegate = CardListViewModelDelegateSpy()
                cards = [Card(id: "0", name: "Card1", cardSetID: "0")]
                cardSets = [CardSet(id: "0", name: "Set1", cards: cards)]
            }
            
            context("when it's initialized") {
                it("should have the given state and delegate, and an empty array of CardSet") {
                    sut = CardListViewModel(state: .loading(cardSets), delegate: delegate)
                    
                    expect(sut.state).to(equal(CardListViewModel.UIState.loading(cardSets)))
                    expect(sut.delegate).to(beIdenticalTo(delegate))
                    expect(sut.cardSets).to(equal(cardSets))
                }
                
                it("should have the given state, delegate and aray of CardSet") {
                    sut = CardListViewModel(state: .success(cardSets), delegate: delegate)
                    
                    expect(sut.state).to(equal(CardListViewModel.UIState.success(cardSets)))
                    expect(sut.delegate).to(beIdenticalTo(delegate))
                    expect(sut.cardSets.count).to(equal(1))
                }
            }
            
            context("when CardCellViewModel it's created") {
                beforeEach {
                    sut = CardListViewModel(state: .success(cardSets), delegate: delegate)
                }
                
                it("should return a viewModel with the correct card") {
                    let viewModel = sut.cellViewModel(for: IndexPath(row: 0, section: 0))
                    expect(viewModel.card.id).to(equal("0"))
                    
                }
            }
            
            context("when select a card") {
                beforeEach {
                    sut = CardListViewModel(state: .success(cardSets), delegate: delegate)
                }
                
                it("it should call delegate didSelect function") {
                    sut.didSelectCell(at: IndexPath(row: 0, section: 0))
                    
                    expect(delegate.didSelectCard).to(beTrue())
                    expect(delegate.selectedCard).to(beIdenticalTo(cards[0]))
                }
            }
            
            context("when search for card") {
                beforeEach {
                   sut = CardListViewModel(state: .searching, delegate: delegate)
                }
                
                it("should call delegate didEnterSearchText function") {
                    let searchedText = "Abomination of Gudul"
                    sut.didEnterSearchText(searchedText)
                    
                    expect(delegate.didBeginSearch).to(beTrue())
                    expect(delegate.searchedText).to(equal(searchedText))
                }
            }
            
            context("when cancel search") {
                beforeEach {
                   sut = CardListViewModel(state: .searching, delegate: delegate)
                }
                
                it("should call delegate didEnterSearchText function") {
                    sut.didCancelSearch()
                    
                    expect(delegate.canceledSearch).to(beTrue())
                }
            }
        }
    }
}
