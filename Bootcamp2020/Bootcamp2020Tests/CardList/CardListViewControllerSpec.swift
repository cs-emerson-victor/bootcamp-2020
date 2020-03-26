//
//  CardListViewControllerSpec.swift
//  Bootcamp2020Tests
//
//  Created by alexandre.c.ferreira on 17/03/20.
//  Copyright © 2020 Team2. All rights reserved.
//
// swiftlint:disable function_body_length

import Quick
import Nimble
import  RealmSwift
@testable import Bootcamp2020

final class CardListViewControllerSpec: QuickSpec {
    
    override func spec() {
        
        var sut: CardListViewController!
        var screen: CardListScreen!
        var service: NetworkServiceStub!
        var detailDelegate: ShowCardDetailDelegateSpy!
        
        beforeEach {
            
            screen = CardListScreen()
            service = NetworkServiceStub()
            detailDelegate = ShowCardDetailDelegateSpy()
            sut = CardListViewController(service: service, screen: screen, detailDelegate: detailDelegate)
            
            _ = sut.view
        }
        
        afterEach {
            
            screen = nil
            service = nil
            detailDelegate = nil
            sut = nil
        }
        
        describe("CardListViewController") {
            context("when initialized") {
                it("should have the correct given objects") {
                    
                    expect(sut.view).to(beIdenticalTo(screen))
                    expect(sut.service).to(beIdenticalTo(service))
                }
                
                context("the view") {
                    it("should be of the correct type") {
                        
                        expect(sut.view).to(beAKindOf(CardListScreen.self))
                    }
                    
                    it("should have a light status bar") {
                        expect(sut.preferredStatusBarStyle).to(equal(.lightContent))
                    }
                }
            }
            
            context("after loading view") {
                it("should fetch initially") {
                    expect(sut.sets).to(equal(service.fetchedSets))
                }
            }
            
            context("when fetching cards for set") {
                var set: CardSet!
                var cards: [Card]!
                
                beforeEach {
                    set = service.fetchedSets[0]
                    cards = set.cards
                }
                
                it("should add the correct cards to set") {
                    set.cards.removeAll()
                    sut.fetchCardsForSet(set)
                    
                    expect(set.cards).to(equal(cards))
                }
                
                it("should not add cards if the set is alreay loaded") {
                    sut.fetchCardsForSet(set)
                    
                    expect(set.cards).to(equal(cards))
                }
                
                it("should not add cards if the state is loading") {
                    let viewModel = CardListViewModel(state: .loading([]), delegate: sut)
                    
                    screen.bind(to: viewModel)
                    set.cards.removeAll()
                    sut.fetchCardsForSet(set)
                    
                    expect(set.cards).to(equal([]))
                }
            }
            
            context("when handling an error") {
                var error: ServiceError?
                
                afterEach {
                    error = nil
                }
                
                it("should change the view state to api error") {
                    error = .apiError
                    sut.handleError(error!)
                    
                    switch screen.viewModel.state {
                    case .error(let sutType):
                        expect(sutType).to(equal(.api))
                    default:
                        Nimble.fail("Wrong state type, should be api")
                    }
                }
                
                it("should change the view state to internet error") {
                    error = .networkError
                    sut.handleError(error!)
                    
                    switch screen.viewModel.state {
                    case .error(let sutType):
                        expect(sutType).to(equal(.noInternet))
                    default:
                        Nimble.fail("Wrong state type, should be noInternet")
                    }
                }
                
                it("should change the view state to generic error") {
                    error = .defaultError
                    sut.handleError(error!)
                    
                    switch screen.viewModel.state {
                    case .error(let sutType):
                        expect(sutType).to(equal(.generic))
                    default:
                        Nimble.fail("Wrong state type, should be generic")
                    }
                }
                
            }
            
            context("when sorting array of sets") {
                it("should return the sets sorted by release data") {
                    let sets = CardSetStub().getEmptySets()
                    let sortedSets = sets.sorted(by: { $0.releaseDate > $1.releaseDate })
                    
                    expect(sut.sortSets(sets)).to(equal(sortedSets))
                }
            }
            
            context("when converting list of cards in dictionary with set id") {
                it("should return the correct sets") {
                    // Arrange
                    let sets = CardSetStub().getFullSets()
                    let correctCardsBySetId = CardSetStub().getCardsBySetIdDict()
                    
                    // Act
                    let allCards = sets.reduce([]) { (all, set) -> [Card] in
                        return all + set.cards
                    }
                    let cardsBySetId = sut.cardsBySetId(allCards)
                    
                    // Assert
                    expect(cardsBySetId).to(equal(correctCardsBySetId))
                }
            }
            
            context("when making copies of sets using a dictionary") {
                it("should return the correct sets") {
                    // Arrange
                    let sets = CardSetStub().getFullSets()
                    let dict = CardSetStub().getCardsBySetIdDict()
                    
                    // Act
                    var setsCopies = sut.makeSetsCopies(withDictionaty: dict)
                    setsCopies.sort(by: { Int($0.id)! < Int($1.id)! })
                    
                    // Assert
                    expect(setsCopies.map { $0.id }).to(equal(sets.map { $0.id }))
                    expect(setsCopies.map { $0.name }).to(equal(sets.map { $0.name }))
                }
            }
            
            context("when handling view model delegate") {
                context("set state") {
                    it("should change screen state to initial loading") {
                        sut.didSet(.initialLoading)
                        
                        expect(screen.viewModel.state).to(equal(.initialLoading))
                    }
                    
                    it("should change screen state to loading") {
                        sut.didSet(.loading([]))
                        
                        expect(screen.viewModel.state).to(equal(.loading([])))
                    }
                    
                    it("should change screen state to success") {
                        sut.didSet(.success([]))
                        
                        expect(screen.viewModel.state).to(equal(.success([])))
                    }
                    
                    it("should change screen state to error") {
                        sut.didSet(.error(.generic))
                        
                        expect(screen.viewModel.state).to(equal(.error(.generic)))
                    }
                    
                    it("should change screen state to searching") {
                        sut.didSet(.searching)
                        
                        expect(screen.viewModel.state).to(equal(.searching))
                    }
                    
                    it("should change screen state to search success") {
                        sut.didSet(.searchSuccess([]))
                        
                        expect(screen.viewModel.state).to(equal(.searchSuccess([])))
                    }
                }
                
                context("did select card ") {
                    it("should show the selected set focusing on the correct card") {
                        let set = CardSetStub().getFullSets().first!
                        let card = set.cards.first!
                        
                        sut.didSelect(card, of: set)
                        
                        expect(detailDelegate.didShowCardSet).to(beTrue())
                        expect(detailDelegate.showedCardSet).to(be(set))
                        expect(detailDelegate.selectedCardId).to(equal(card.id))
                    }
                }
                
                context("did prefetch set") {
                    it("should fetch cards of set") {
                        let set = CardSet(id: "0", name: "Set 0")
                        
                        sut.prefetchSet(set)
                        
                        expect(set.cards).toNot(beEmpty())
                    }
                }
                
                context("did enter search text") {
                    it("should search card with given text") {
                        let name = "Card 0"
                        
                        sut.didEnterSearchText(name)
                        
                        if case .searchSuccess(let cards) = screen.viewModel.state {
                            expect(cards).toNot(beEmpty())
                        } else {
                            Nimble.fail("Did not fetch card by name")
                        }
                    }
                    
                    it("should show empty search error when returns nothing") {
                        sut.didEnterSearchText("")
                        
                        expect(screen.viewModel.state).to(equal(.error(.emptySearch(""))))
                    }
                }
                
                context("did cancel search") {
                    it("should not change to search state") {
                        sut.didEnterSearchText("Card 0")
                        sut.didCancelSearch()
                        
                        expect(screen.viewModel.state).to(equal(.success(sut.sets)))
                    }
                }
            }
        }
    }
}
