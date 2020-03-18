//
//  EndpointSpec.swift
//  Bootcamp2020Tests
//
//  Created by jacqueline alves barbosa on 17/03/20.
//  Copyright © 2020 Team2. All rights reserved.
//

@testable import Bootcamp2020

import Quick
import Nimble

class EndpointSpec: QuickSpec {
    override func spec() {
        var sut: Endpoint!
        
        let baseURL = "https://api.magicthegathering.io/v1"
        
        describe("The Endpoint") {
            context("when generating an url") {
                var correctURL: String!
                
                context("for sets") {
                    
                    beforeEach {
                        correctURL = "\(baseURL)/sets?"

                        sut = Endpoint(ofType: .sets)
                    }
                    
                    it("should return the correct url") {
                        expect(sut.url).toNot(beNil())
                        expect(sut.url!.absoluteString).to(equal(correctURL))
                    }
                }
                
                context("for cards in set") {
                    var set: CardSet!
                    
                    beforeEach {
                        correctURL = "\(baseURL)/cards?set=KTK"
                        set = CardSet()
                        set.name = "KTK"
                        
                        sut = Endpoint(ofType: .cards(set: set))
                    }
                    
                    it("should return the correct url") {
                        expect(sut.url).toNot(beNil())
                        expect(sut.url?.absoluteString).to(equal(correctURL))
                    }
                }
                
                context("for cards with name") {
                    var name: String!
                    
                    beforeEach {
                        correctURL = "\(baseURL)/cards?name=Abomination%20of%20Gudul"
                        name = "Abomination of Gudul"
                        
                        sut = Endpoint(ofType: .card(name: name))
                    }
                    
                    it("should return the correct url") {
                        expect(sut.url).toNot(beNil())
                        expect(sut.url!.absoluteString).to(equal(correctURL))
                    }
                }
            }
        }
    }
}
