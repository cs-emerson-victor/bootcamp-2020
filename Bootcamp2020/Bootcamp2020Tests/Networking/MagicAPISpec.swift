//
//  MagicAPISpec.swift
//  Bootcamp2020Tests
//
//  Created by jacqueline alves barbosa on 08/04/20.
//  Copyright © 2020 Team2. All rights reserved.
//
// swiftlint:disable function_body_length

@testable import Bootcamp2020
import Quick
import Nimble

class MagicAPISpec: QuickSpec {
    override func spec() {
        var sut: MagicAPI!
        
        describe("MagicAPI EndPoint") {
            
            afterEach {
                sut = nil
            }
            
            context("for card sets") {
                beforeEach {
                    sut = MagicAPI.sets
                }
                
                it("should have the correct base url") {
                    expect(sut.baseURL.absoluteString).to(equal("https://api.magicthegathering.io/v1/"))
                }
                
                it("should have the correct path") {
                    expect(sut.path).to(equal("sets"))
                }
                
                it("should have the correct http method") {
                    expect(sut.httpMethod).to(equal(.get))
                }
                
                it("should have the correct http task") {
                    if case .request = sut.task {
                        _ = Nimble.succeed()
                    } else {
                        Nimble.fail()
                    }
                }
                
                it("should have the correct header") {
                    expect(sut.headers).to(beNil())
                }
            }
            
            context("for cards by set") {
                let set = CardSetStub().getEmptySets().first!
                
                beforeEach {
                    sut = MagicAPI.cards(set: set, page: 1)
                }
                
                it("should have the correct base url") {
                    expect(sut.baseURL.absoluteString).to(equal("https://api.magicthegathering.io/v1/"))
                }
                
                it("should have the correct path") {
                    expect(sut.path).to(equal("cards"))
                }
                
                it("should have the correct http method") {
                    expect(sut.httpMethod).to(equal(.get))
                }
                
                it("should have the correct http task") {
                    if case let .requestParameters(bodyParameters, urlParameters) = sut.task {
                        expect(bodyParameters).to(beNil())
                        expect(urlParameters?["set"] as? String).to(equal(set.id))
                        expect(urlParameters?["page"] as? Int).to(equal(1))
                    } else {
                        Nimble.fail()
                    }
                }
                
                it("should have the correct header") {
                    expect(sut.headers).to(beNil())
                }
            }
            
            context("for cards by name") {
                let cardName = "Card"
                
                beforeEach {
                    sut = MagicAPI.card(name: cardName)
                }
                
                it("should have the correct base url") {
                    expect(sut.baseURL.absoluteString).to(equal("https://api.magicthegathering.io/v1/"))
                }
                
                it("should have the correct path") {
                    expect(sut.path).to(equal("cards"))
                }
                
                it("should have the correct http method") {
                    expect(sut.httpMethod).to(equal(.get))
                }
                
                it("should have the correct http task") {
                    if case let .requestParameters(bodyParameters, urlParameters) = sut.task {
                        expect(bodyParameters).to(beNil())
                        if let urlParameters = urlParameters as? [String: String] {
                            expect(urlParameters).to(equal(["name": cardName]))
                        } else {
                            Nimble.fail()
                        }
                    } else {
                        Nimble.fail()
                    }
                }
                
                it("should have the correct header") {
                    expect(sut.headers).to(beNil())
                }
            }
        }
    }
}
