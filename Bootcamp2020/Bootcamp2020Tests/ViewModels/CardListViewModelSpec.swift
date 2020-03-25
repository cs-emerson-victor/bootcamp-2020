//
//  CardListViewModelSpec.swift
//  Bootcamp2020Tests
//
//  Created by emerson.victor.f.luz on 18/03/20.
//  Copyright © 2020 Team2. All rights reserved.
//
// swiftlint:disable function_body_length

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
            
            context("when CardCellViewModel is created") {
                beforeEach {
                    sut = CardListViewModel(state: .success(cardSets), delegate: delegate)
                }
                
                it("should return a viewModel with the correct card") {
                    let type = sut.cellType(for: IndexPath(row: 0, section: 0))
                    if case CellType.card(let viewModel) = type {
                        expect(viewModel.card.id).to(equal("0"))
                    } else {
                        Nimble.fail("Card cell type wrong")
                    }
                }
                
                // TODO: Test type header cell
            }
            
            context("when selecting a card") {
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
            
            context("when state is of error") {
                it("should display API") {
                    let type = ErrorType.api
                    sut = CardListViewModel(state: .error(type), delegate: delegate)
                    
                    switch sut.state {
                    case .error(let sutType):
                        expect(sutType).to(equal(type))
                    default:
                        Nimble.fail("Wrong state type, should be error")
                    }
                }
                
                it("should display empty search") {
                    let searchedText = "test search message"
                    let type = ErrorType.emptySearch(searchedText)
                    sut = CardListViewModel(state: .error(type), delegate: delegate)
                    
                    switch sut.state {
                    case .error(let sutType):
                        expect(sutType).to(equal(type))
                    default:
                        Nimble.fail("Wrong state type, should be error")
                    }
                }
                
                it("should display generic") {
                    let type = ErrorType.generic
                    sut = CardListViewModel(state: .error(type), delegate: delegate)
                    
                    switch sut.state {
                    case .error(let sutType):
                        expect(sutType).to(equal(type))
                    default:
                        Nimble.fail("Wrong state type, should be error")
                    }
                }
                
                it("should display no internet") {
                    let type = ErrorType.noInternet
                    sut = CardListViewModel(state: .error(type), delegate: delegate)
                    
                    switch sut.state {
                    case .error(let sutType):
                        expect(sutType).to(equal(type))
                    default:
                        Nimble.fail("Wrong state type, should be error")
                    }
                }
            }
        }
    }
}
