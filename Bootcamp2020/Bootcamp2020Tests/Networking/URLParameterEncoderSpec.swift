//
//  URLParameterEncoderSpec.swift
//  Bootcamp2020Tests
//
//  Created by jacqueline alves barbosa on 07/04/20.
//  Copyright © 2020 Team2. All rights reserved.
//

@testable import Bootcamp2020
import Quick
import Nimble

final class URLParameterEncoderSpec: QuickSpec {
    override func spec() {
        var request: URLRequest!
        var parameters: Parameters!
        let baseURL = "https://api.magicthegathering.io/v1/cards"
        
        describe("URLParameterEncoderSpec") {
            afterEach {
                request = nil
                parameters = nil
            }
            
            context("when enconding") {
                it("should add parameters to url request correctly") {
                    let correctRequest = URLRequest(url: URL(string: "\(baseURL)?name=Abomination%20of%20Gudul")!)
                    
                    request = URLRequest(url: URL(string: baseURL)!)
                    parameters = ["name": "Abomination of Gudul"]
                    
                    try? URLParameterEncoder.encode(urlRequest: &request, with: parameters)
                    
                    expect(request.url).to(equal(correctRequest.url))
                }
            }
        }
    }
}
