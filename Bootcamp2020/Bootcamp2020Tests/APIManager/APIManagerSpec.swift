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
        let session = URLSessionMock()
        let stub = CardsAndSetsStub()
        let sut = APIManager(session: session)
        var data: Data?
        
        describe("The API Manager") {
            let baseURL = "https://api.magicthegathering.io/v1/cards?"
            
            context("when composing and URL") {
                let url: URL? = URL(string: baseURL)
                var params: APIManager.Params?
                var composedURL: URL?
                
                context("with valid URL without params") {
                    beforeEach {
                        params = nil
                        composedURL = sut.composeURL(url, withParams: params)
                    }
                    
                    it("should return the same URL") {
                        expect(composedURL).to(equal(url))
                    }
                }
                
                context("with valid URL and params") {
                    beforeEach {
                        params = ["page": "1"]
                        composedURL = sut.composeURL(url, withParams: params)
                    }
                    
                    it("should return the same URL") {
                        expect(composedURL).to(equal(URL(string: "\(url!.absoluteString)page=1")))
                    }
                }
                
                context("with invalid URL") {
                    beforeEach {
                        params = nil
                        composedURL = sut.composeURL(nil, withParams: params)
                    }
                    
                    it("should return nil") {
                        expect(composedURL).to(beNil())
                    }
                }
            }
            
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
                        
                        let response = HTTPURLResponse(url: URL(string: baseURL)!, statusCode: 200, httpVersion: nil, headerFields: ["total-count": "2"])
                        session.response = response
                        
                    }
                    
                    it("should return the expected cards") {
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
                                Nimble.fail(error.localizedDescription)
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
