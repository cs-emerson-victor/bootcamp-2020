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
        
        beforeEach {
            
            screen = CardListScreen()
            service = NetworkServiceStub()
            sut = CardListViewController(service: service, screen: screen)
            
            _ = sut.view
        }
        
        afterEach {
            
            screen = nil
            service = nil
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
                }
            }
            
            context("after loading view") {
                it("should fetch initially") {
                    expect(sut.sets).to(equal(service.fetchedSets))
                }
            }
            
            context("when fetching cards for set") {
                var set: CardSet!
                var cards: List<Card>!
                
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
                    let viewModel = CardListViewModel(state: .loading([]), delegate: CardListViewModelDelegateDummy())
                    
                    screen.bind(to: viewModel)
                    set.cards.removeAll()
                    sut.fetchCardsForSet(set)
                    
                    expect(set.cards).to(equal(cards))
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
               // TODO: Check this implementation
                it("should return the correct sets") {
                    // Arrange
                    let sets = CardSetStub().getFullSets()
                    let correctCardsBySetId = CardSetStub().getCardsBySetId(sets)
                    
                    // Act
                    let allCards = sets.reduce([]) { (all, set) -> [Card] in
                        return all + Array(set.cards)
                    }
                    let cardsBySetId = sut.cardsBySetId(allCards)
                    
                    // Assert
                    expect(cardsBySetId).to(equal(correctCardsBySetId))
                }
            }
            
            context("when making copies of sets using a dictionary") {
                // TODO: Check this implementation
                it("should return the correct sets") {
                    // Arrange
                    let sets = CardSetStub().getFullSets()
                    let dict = CardSetStub().getCardsBySetId(sets)
                    
                    // Act
                    var setsCopies = sut.makeSetsCopies(withDictionaty: dict)
                    setsCopies.sort(by: { Int($0.id)! < Int($1.id)! })
                    
                    // Assert
                    expect(setsCopies.map { $0.id }).to(equal(sets.map { $0.id }))
                    expect(setsCopies.map { $0.name }).to(equal(sets.map { $0.name }))
                }
            }
        }
    }
}
