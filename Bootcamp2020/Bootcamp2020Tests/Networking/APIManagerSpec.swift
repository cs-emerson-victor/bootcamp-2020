//
//  APIManagerSpec.swift
//  Bootcamp2020Tests
//
//  Created by jacqueline alves barbosa on 16/03/20.
//  Copyright © 2020 Team2. All rights reserved.
//
// swiftlint:disable function_body_length cyclomatic_complexity

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
            
            context("when handle network response") {
                afterEach {
                    response = nil
                }
                
                it("should return success") {
                    response = HTTPURLResponse(url: URL(string: baseURL)!, statusCode: 200, httpVersion: nil, headerFields: nil)
                    
                    let result = sut.handleNetworkResponse(response!)
                    
                    if case .success = result {
                        _ = Nimble.succeed()
                    } else {
                        Nimble.fail()
                    }
                }
                
                it("should return bad request") {
                    response = HTTPURLResponse(url: URL(string: baseURL)!, statusCode: 400, httpVersion: nil, headerFields: nil)
                    
                    let result = sut.handleNetworkResponse(response!)
                    
                    if case .failure(.badRequest) = result {
                        _ = Nimble.succeed()
                    } else {
                        Nimble.fail()
                    }
                }
                
                it("should return forbidden") {
                    response = HTTPURLResponse(url: URL(string: baseURL)!, statusCode: 403, httpVersion: nil, headerFields: nil)
                    
                    let result = sut.handleNetworkResponse(response!)
                    
                    if case .failure(.forbidden) = result {
                        _ = Nimble.succeed()
                    } else {
                        Nimble.fail()
                    }
                }
                
                it("should return not found") {
                    response = HTTPURLResponse(url: URL(string: baseURL)!, statusCode: 404, httpVersion: nil, headerFields: nil)
                    
                    let result = sut.handleNetworkResponse(response!)
                    
                    if case .failure(.notFound) = result {
                        _ = Nimble.succeed()
                    } else {
                        Nimble.fail()
                    }
                }
                
                it("should return internal server error") {
                    response = HTTPURLResponse(url: URL(string: baseURL)!, statusCode: 500, httpVersion: nil, headerFields: nil)
                    
                    let result = sut.handleNetworkResponse(response!)
                    
                    if case .failure(.internalServerError) = result {
                        _ = Nimble.succeed()
                    } else {
                        Nimble.fail()
                    }
                }
                
                it("should return service unavailable") {
                    response = HTTPURLResponse(url: URL(string: baseURL)!, statusCode: 503, httpVersion: nil, headerFields: nil)
                    
                    let result = sut.handleNetworkResponse(response!)
                    
                    if case .failure(.serviceUnavailable) = result {
                        _ = Nimble.succeed()
                    } else {
                        Nimble.fail()
                    }
                }
                
                it("should return failed") {
                    response = HTTPURLResponse(url: URL(string: baseURL)!, statusCode: 600, httpVersion: nil, headerFields: nil)
                    
                    let result = sut.handleNetworkResponse(response!)
                    
                    if case .failure(.failed) = result {
                        _ = Nimble.succeed()
                    } else {
                        Nimble.fail()
                    }
                }
            }
            
            context("when decoding completion") {
                var correctData: Codable!
                var data: Data!
                
                afterEach {
                    correctData = nil
                    data = nil
                }
                
                it("should show return api error when error") {
                    correctData = stub.fetchByNameCards
                    data = try? JSONEncoder().encode(correctData as? CardsResponse)
                    response = HTTPURLResponse(url: URL(string: baseURL)!, statusCode: 200, httpVersion: nil, headerFields: [:])
                    
                    waitUntil { done in
                        sut.decodeCompletion(data: data, response: response, error: APIManager.NetworkError.failed) { (result: Result<CardsResponse, ServiceError>) in
                            
                            switch result {
                            case .failure(let error):
                                expect(error).to(equal(ServiceError.apiError))
                            default:
                                Nimble.fail("It should have returned error")
                            }
                            
                            done()
                        }
                    }
                }
                
                it("should show return api error when invalid response") {
                    correctData = stub.fetchByNameCards
                    data = try? JSONEncoder().encode(correctData as? CardsResponse)
                    
                    waitUntil { done in
                        sut.decodeCompletion(data: data, response: response, error: nil) { (result: Result<CardsResponse, ServiceError>) in
                            
                            switch result {
                            case .failure(let error):
                                expect(error).to(equal(ServiceError.apiError))
                            default:
                                Nimble.fail("It should have returned error")
                            }
                            
                            done()
                        }
                    }
                }
                
                it("should decode cards correcty") {
                    correctData = stub.fetchByNameCards
                    data = try? JSONEncoder().encode(correctData as? CardsResponse)
                    response = HTTPURLResponse(url: URL(string: baseURL)!, statusCode: 200, httpVersion: nil, headerFields: [:])
                    
                    waitUntil { done in
                        sut.decodeCompletion(data: data, response: response, error: nil) { (result: Result<CardsResponse, ServiceError>) in
                            switch result {
                            case .success(let cardsResponse):
                                expect(cardsResponse.cards).to(equal((correctData as? CardsResponse)?.cards))
                            default:
                                Nimble.fail("It should have decoded correctly")
                            }
                            
                            done()
                        }
                    }
                }
                
                it("should decode sets correcty") {
                    correctData = stub.cardSets
                    data = try? JSONEncoder().encode(correctData as? CardSetsResponse)
                    response = HTTPURLResponse(url: URL(string: baseURL)!, statusCode: 200, httpVersion: nil, headerFields: [:])
                    
                    waitUntil { done in
                        sut.decodeCompletion(data: data, response: response, error: nil) { (result: Result<CardSetsResponse, ServiceError>) in
                            switch result {
                            case .success(let setsResponse):
                                expect(setsResponse.sets).to(equal((correctData as? CardSetsResponse)?.sets))
                            default:
                                Nimble.fail("It should have decoded correctly")
                            }
                            
                            done()
                        }
                    }
                }
            }
        }
    }
}
