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
        let stub = CardsAndCollectionsStub()
        let sut = APIManager(session: session)
        var data: Data!
        
        describe("The API Manager") {
            context("when fetching a card") {
                var correctCards: [Card] = []
                
                context("by it's name") {
                    beforeEach {
                        correctCards = stub.fetchByNameCards.cards
                        let test = try? JSONEncoder().encode(stub.fetchByNameCards.cards)
                        data = try? NSKeyedArchiver.archivedData(withRootObject: stub.fetchByNameCards, requiringSecureCoding: false)
                        session.data = data
                    }
                    
                    it("should return the expected cards") {
                        waitUntil { done in
                            sut.fetchCard(withName: "Abomination of Gudul") { result in
                                switch result {
                                case .failure(let error):
                                    fail(error.localizedDescription)
                                case .success(let cards):
                                    expect(cards).to(equal(correctCards))
                                }
                                
                                done()
                            }
                        }
                    }
                }
            }
        }
    }
}
