//
//  RouterSpec.swift
//  Bootcamp2020Tests
//
//  Created by jacqueline alves barbosa on 08/04/20.
//  Copyright © 2020 Team2. All rights reserved.
//
// swiftlint:disable function_body_length

@testable import Bootcamp2020
import Quick
import Nimble

class RouterSpec: QuickSpec {
    override func spec() {
        var session: URLSessionMock!
        var sut: Router<EndPointMock>!
        var parameters: Parameters!
        var correctRequest: URLRequest!
        var request: URLRequest!
        let baseURL = "https://api.magicthegathering.io/v1"
        
        describe("Router") {
            beforeEach {
                session = URLSessionMock()
                sut = Router<EndPointMock>(session: session)
                parameters = ["name": "Abomination of Gudul"]
            }
            
            afterEach {
                session = nil
                sut = nil
                parameters = nil
                correctRequest = nil
                request = nil
            }
            
            context("when configure parameters") {
                it("should configure url parameters correctly") {
                    correctRequest = URLRequest(url: URL(string: "\(baseURL)?name=Abomination%20of%20Gudul")!)
                    request = URLRequest(url: URL(string: baseURL)!)
                    
                    try? sut.configureParameters(bodyParameters: nil, urlParameters: parameters, request: &request)
                    
                    expect(request.url).to(equal(correctRequest.url))
                }
                
                it("should configure body parameters correctly") {
                    correctRequest = URLRequest(url: URL(string: baseURL)!)
                    correctRequest.httpBody = try? JSONSerialization.data(withJSONObject: parameters ?? [:], options: .prettyPrinted)
                    
                    request = URLRequest(url: URL(string: baseURL)!)
                    
                    try? sut.configureParameters(bodyParameters: parameters, urlParameters: nil, request: &request)
                    
                    expect(request.url).to(equal(correctRequest.url))
                    expect(request.httpBody).to(equal(correctRequest.httpBody))
                }
            }
            
            context("when build a request") {
                it("should return the correct request for endpoint without parameters") {
                    correctRequest = URLRequest(url: URL(string: "\(baseURL)/withoutParameters")!)
                    request = try? sut.buildRequest(from: .withoutParameters)
                    
                    expect(request.url).to(equal(correctRequest.url))
                }
                
                it("should return the correct request for endpoint with url parameters") {
                    correctRequest = URLRequest(url: URL(string: "\(baseURL)/withParameters?name=Abomination%20of%20Gudul")!)
                    request = try? sut.buildRequest(from: .withURLParameter(parameters))
                    
                    expect(request.url).to(equal(correctRequest.url))
                }
                
                it("should return the correct request for endpoint with body parameters") {
                    correctRequest = URLRequest(url: URL(string: "\(baseURL)/withParameters")!)
                    correctRequest.httpBody = try? JSONSerialization.data(withJSONObject: parameters ?? [:], options: .prettyPrinted)
                    
                    request = try? sut.buildRequest(from: .withBodyParameter(parameters))
                    
                    expect(request.url).to(equal(correctRequest.url))
                    expect(request.httpBody).to(equal(correctRequest.httpBody))
                }
            }
            
            context("when cancel") {
                it("should cancel the current task") {
                    sut.request(.withoutParameters) { (_, _, _) in }
                    sut.cancel()
                    
                    expect(session.cancelled).to(beTrue())
                }
            }
            
            context("when request") {
                it("should return the correct data, response and error") {
                    let correctData = try? JSONEncoder().encode(CardsAndSetsStub().fetchByNameCards)
                    let correctResponse = HTTPURLResponse(url: URL(string: baseURL)!, statusCode: 200, httpVersion: nil, headerFields: [:])
                    let correctError = ServiceError.apiError
                    
                    session.response = correctResponse
                    session.data = correctData
                    session.error = correctError
                    
                    waitUntil { done in
                        sut.request(.withoutParameters) { (data, response, error) in
                            expect(data).to(equal(correctData))
                            expect(response).to(equal(correctResponse))
                            
                            if let error = error as? ServiceError {
                                expect(error).to(equal(correctError))
                            }
                            
                            done()
                        }
                    }
                }
            }
        }
    }
}
