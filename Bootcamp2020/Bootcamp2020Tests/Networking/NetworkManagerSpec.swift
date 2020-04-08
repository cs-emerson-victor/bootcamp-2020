//
//  NetworkManagerSpec.swift
//  Bootcamp2020Tests
//
//  Created by jacqueline alves barbosa on 08/04/20.
//  Copyright © 2020 Team2. All rights reserved.
//
// swiftlint:disable function_body_length cyclomatic_complexity

@testable import Bootcamp2020
import Quick
import Nimble

final class NetworkManagerSpec: QuickSpec {
    override func spec() {
        var session: URLSessionMock!
        var stub: CardsAndSetsStub!
        var sut: NetworkManager<EndPointMock>!
        var response: HTTPURLResponse?
        
        describe("Network Manager") {
            let baseURL = "https://api.magicthegathering.io/v1"
            
            beforeEach {
                session = URLSessionMock()
                stub = CardsAndSetsStub()
                sut = NetworkManager<EndPointMock>(session: session)
            }
            
            afterEach {
                session = nil
                stub = nil
                response = nil
                sut = nil
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
                    
                    sut.decodeCompletion(data: data, response: response, error: NetworkError.encodingFailed) { (result: Result<CardsResponse, ServiceError>) in
                        
                        switch result {
                        case .failure(let error):
                            expect(error).to(equal(ServiceError.apiError))
                        default:
                            Nimble.fail("It should have returned error")
                        }
                    }
                }
                
                it("should show return api error when invalid response") {
                    correctData = stub.fetchByNameCards
                    data = try? JSONEncoder().encode(correctData as? CardsResponse)
                    
                    sut.decodeCompletion(data: data, response: response, error: nil) { (result: Result<CardsResponse, ServiceError>) in
                        
                        switch result {
                        case .failure(let error):
                            expect(error).to(equal(ServiceError.apiError))
                        default:
                            Nimble.fail("It should have returned error")
                        }
                    }
                }
                
                it("should decode cards correcty") {
                    correctData = stub.fetchByNameCards
                    data = try? JSONEncoder().encode(correctData as? CardsResponse)
                    response = HTTPURLResponse(url: URL(string: baseURL)!, statusCode: 200, httpVersion: nil, headerFields: [:])
                    
                    sut.decodeCompletion(data: data, response: response, error: nil) { (result: Result<CardsResponse, ServiceError>) in
                        switch result {
                        case .success(let cardsResponse):
                            expect(cardsResponse.cards).to(equal((correctData as? CardsResponse)?.cards))
                        default:
                            Nimble.fail("It should have decoded correctly")
                        }
                    }
                }
                
                it("should decode sets correcty") {
                    correctData = stub.cardSets
                    data = try? JSONEncoder().encode(correctData as? CardSetsResponse)
                    response = HTTPURLResponse(url: URL(string: baseURL)!, statusCode: 200, httpVersion: nil, headerFields: [:])
                    
                    sut.decodeCompletion(data: data, response: response, error: nil) { (result: Result<CardSetsResponse, ServiceError>) in
                        switch result {
                        case .success(let setsResponse):
                            expect(setsResponse.sets).to(equal((correctData as? CardSetsResponse)?.sets))
                        default:
                            Nimble.fail("It should have decoded correctly")
                        }
                    }
                }
            }
            
            context("when fetch") {
                var correctData: CardsResponse!
                
                beforeEach {
                    correctData = stub.fetchBySetCards
                    session.data = try? JSONEncoder().encode(correctData)
                }
                
                it("should return success with the correct data") {
                    response = HTTPURLResponse(url: URL(string: baseURL)!, statusCode: 200, httpVersion: nil, headerFields: [:])
                    session.response = response
                    
                    sut.fetch(from: .withoutParameters) { (result: Result<CardsResponse, ServiceError>) in
                        switch result {
                        case .success(let response):
                            expect(response.cards).to(equal(correctData.cards))
                        case .failure:
                            Nimble.fail()
                        }
                    }
                }
                
                it("should return success with the correct data and page count") {
                    response = HTTPURLResponse(url: URL(string: baseURL)!,
                                               statusCode: 200,
                                               httpVersion: nil,
                                               headerFields: ["total-count": "\(correctData.cards.count)"])
                    
                    session.response = response
                    
                    sut.fetch(from: .withoutParameters,
                              returningHeaderFields: ["total-count"]) { (result: Result<(data: CardsResponse, fields: [AnyHashable: Any]), ServiceError>) in
                                
                            switch result {
                            case .success(let response):
                                expect(response.data.cards).to(equal(correctData.cards))
                                if let totalCardCount = response.fields["total-count"] as? String {
                                    expect(totalCardCount).to(equal("\(correctData.cards.count)"))
                                } else {
                                    Nimble.fail()
                                }
                            case .failure:
                                Nimble.fail()
                            }
                    }
                }
                
                it("should return failure if there is an error") {
                    response = HTTPURLResponse(url: URL(string: baseURL)!, statusCode: 200, httpVersion: nil, headerFields: [:])
                    session.response = response
                    session.error = ServiceError.apiError
                    
                    sut.fetch(from: .withoutParameters) { (result: Result<CardsResponse, ServiceError>) in
                        switch result {
                        case .success:
                            Nimble.fail()
                        case .failure(let error):
                            expect(error).to(equal(ServiceError.apiError))
                        }
                    }
                }
                
                it("should return failure if there is an error") {
                    response = HTTPURLResponse(url: URL(string: baseURL)!, statusCode: 200, httpVersion: nil, headerFields: [:])
                    session.response = response
                    session.error = ServiceError.apiError
                    
                    sut.fetch(from: .withoutParameters,
                              returningHeaderFields: ["total-count"]) { (result: Result<(data: CardsResponse, fields: [AnyHashable: Any]), ServiceError>) in
                        switch result {
                        case .success:
                            Nimble.fail()
                        case .failure(let error):
                            expect(error).to(equal(ServiceError.apiError))
                        }
                    }
                }
            }
        }
    }
}
