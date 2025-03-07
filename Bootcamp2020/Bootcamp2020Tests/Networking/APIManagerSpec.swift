//
//  APIManagerSpec.swift
//  Bootcamp2020Tests
//
//  Created by jacqueline alves barbosa on 16/03/20.
//  Copyright © 2020 Team2. All rights reserved.
//
// swiftlint:disable function_body_length

@testable import Bootcamp2020
import Quick
import Nimble

class APIManagerSpec: QuickSpec {
    override func spec() {
        var session: URLSessionMock!
        var stub: CardsAndSetsStub!
        var sut: APIManager!
        var data: Data?
        var response: HTTPURLResponse?
        
        describe("The API Manager") {
            let baseURL = "https://api.magicthegathering.io/v1/cards?"
            
            beforeEach {
                session = URLSessionMock()
                stub = CardsAndSetsStub()
                sut = APIManager(session: session)
            }
            
            afterEach {
                session = nil
                stub = nil
                data = nil
                response = nil
                sut = nil
            }
            
            context("when fetching a card") {
                var correctCards: [Card] = []
                
                context("by it's name") {
                    beforeEach {
                        correctCards = stub.fetchByNameCards.cards
                        data = try? JSONEncoder().encode(stub.fetchByNameCards)
                        session.data = data
                        
                        response = HTTPURLResponse(url: URL(string: baseURL)!, statusCode: 200, httpVersion: nil, headerFields: [:])
                        session.response = response
                    }
                    
                    it("should return the expected cards") {
                        waitUntil { done in
                            sut.fetchCards(withName: "Abomination of Gudul") { result in
                                switch result {
                                case .failure(let error):
                                    Nimble.fail(error.localizedDescription)
                                case .success(let cards):
                                    expect(cards.elementsEqual(correctCards, by: { $0.id == $1.id })).to(beTrue())
                                }
                                
                                done()
                            }
                        }
                    }
                }
                
                context("by it's set") {
                    let set = CardSet(id: "1", name: "KTK")
                    
                    beforeEach {
                        correctCards = stub.fetchBySetCards.cards
                        data = try? JSONEncoder().encode(stub.fetchBySetCards)
                        session.data = data
                    }
                    
                    context("with one page") {
                        it("should return the expected cards") {
                            response = HTTPURLResponse(url: URL(string: baseURL)!, statusCode: 200, httpVersion: nil, headerFields: ["total-count": "2"])
                            session.response = response
                            
                            waitUntil { done in
                                sut.fetchCards(ofSet: set) { result in
                                    switch result {
                                    case .failure(let error):
                                        Nimble.fail(error.localizedDescription)
                                    case .success(let cards):
                                        expect(cards.elementsEqual(correctCards, by: { $0.id == $1.id })).to(beTrue())
                                    }
                                    
                                    done()
                                }
                            }
                        }
                    }
                    
                    context("with more than one page") {
                        it("should return the expected cards") {
                            correctCards.append(contentsOf: correctCards)
                            
                            response = HTTPURLResponse(url: URL(string: baseURL)!, statusCode: 200, httpVersion: nil, headerFields: ["total-count": "200"])
                            session.response = response
                            
                            waitUntil { done in
                                sut.fetchCards(ofSet: set) { result in
                                    switch result {
                                    case .failure(let error):
                                        Nimble.fail(error.localizedDescription)
                                    case .success(let cards):
                                        expect(cards.elementsEqual(correctCards, by: { $0.id == $1.id })).to(beTrue())
                                    }
                                    
                                    done()
                                }
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
                    
                    response = HTTPURLResponse(url: URL(string: baseURL)!, statusCode: 200, httpVersion: nil, headerFields: [:])
                    session.response = response
                }
                
                it("should return the expected sets") {
                    waitUntil { done in
                        sut.fetchSets { result in
                            switch result {
                            case .failure(let error):
                                Nimble.fail(error.localizedDescription)
                            case .success(let sets):
                                expect(sets.elementsEqual(correctSets, by: { $0.id == $1.id })).to(beTrue())
                            }
                            
                            done()
                        }
                    }
                }
            }
            
            it("should not reload automatically") {
                expect(sut.shouldUpdateSetsAutomatically).to(beFalse())
            }
        }
    }
}
