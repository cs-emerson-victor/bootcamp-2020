//
//  APIManagerSpec.swift
//  Bootcamp2020Tests
//
//  Created by jacqueline alves barbosa on 16/03/20.
//  Copyright © 2020 Team2. All rights reserved.
//

@testable import Bootcamp2020
import Quick
import Nimble

class APIManagerSpec: QuickSpec {
    override func spec() {
        let session = URLSessionMock()
        let stub = CardsAndSetsStub()
        let sut = APIManager(session: session)
        var data: Data?
        
        describe("The API Manager") {
            context("when fetching a card") {
                var correctCards: [Card] = []
                
                context("by it's name") {
                    beforeEach {
                        correctCards = stub.fetchByNameCards.cards
                        data = try? JSONEncoder().encode(stub.fetchByNameCards)
                        session.data = data
                    }
                    
                    it("should return the expected cards") {
                        waitUntil { done in
                            sut.fetchCard(withName: "Abomination of Gudul") { result in
                                switch result {
                                case .failure(let error):
                                    fail(error.localizedDescription)
                                case .success(let cards):
                                    expect(cards.elementsEqual(correctCards, by: { $0.id == $1.id })).to(beTrue())
                                }
                                
                                done()
                            }
                        }
                    }
                }
            }
            
            context("when fetching a set") {
                var correctSets: [CardSet] = []
                
                beforeEach {
                    correctSets = stub.cardSets.sets
                    data = try? JSONEncoder().encode(stub.cardSets)
                    session.data = data
                }
                
                it("should return the expected sets") {
                    waitUntil { done in
                        sut.fetchSets { result in
                            switch result {
                            case .failure(let error):
                                fail(error.localizedDescription)
                            case .success(let sets):
                                expect(sets.elementsEqual(correctSets, by: { $0.id == $1.id })).to(beTrue())
                            }
                            
                            done()
                        }
                    }
                }
                
            }
        }
    }
}
