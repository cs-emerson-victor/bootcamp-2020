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
        var sut: APIManager!
        var endpoint: Endpoint!
        
        let baseURL = "https://api.magicthegathering.io/v1"
        
        describe("The API Manager") {
            beforeSuite {
                sut = APIManager()
            }
            
            context("when get url") {
                context("for collections") {
                    var url: URL!
                    
                    beforeEach {
                        endpoint = Endpoint(of: .collections)
                        url = endpoint.url
                    }
                    
                    it("should return the correct url") {
                        expect(url).toNot(beNil())
                        expect(url).to(beIdenticalTo(URL(string: "\(baseURL)/sets?")!))
                    }
                }
                
                context("for cards in collection") {
                    var url: URL!
                    var collection: Collection!
                    
                    beforeEach {
                        collection = Collection()
                        collection.name = "KTK"
                        endpoint = Endpoint(of: .cards(collection))
                        
                        url = endpoint.url
                    }
                    
                    it("should return the correct url") {
                        expect(url).toNot(beNil())
                        expect(url).to(beIdenticalTo(URL(string: "\(baseURL)/cards?set=KTK")!))
                    }
                }
                
                context("for cards with name") {
                    var url: URL!
                    var name: String!
                    
                    beforeEach {
                        name = "Abomination of Gudul"
                        endpoint = Endpoint(of: .card(name))
                        
                        url = endpoint.url
                    }
                    
                    it("should return the correct url") {
                        expect(url).toNot(beNil())
                        expect(url).to(beIdenticalTo(URL(string: "\(baseURL)/cards?name=Archangel%20Avacyn")!))
                    }
                }
            }
        }
    }
}
