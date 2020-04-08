//
//  EndPointMock.swift
//  Bootcamp2020Tests
//
//  Created by jacqueline alves barbosa on 08/04/20.
//  Copyright © 2020 Team2. All rights reserved.
//

@testable import Bootcamp2020
import Foundation

enum EndPointMock {
    case withoutParameters
    case withURLParameter([String: Any])
    case withBodyParameter([String: Any])
}

extension EndPointMock: EndPointType {
    var baseURL: URL {
        guard let url = URL(string: "https://api.magicthegathering.io/v1/") else {
            fatalError("baseURL could not be configured.")
        }
        
        return url
    }
    
    var path: String {
        switch self {
        case .withoutParameters:
            return "withoutParameters"
        case .withURLParameter, .withBodyParameter:
            return "withParameters"
        }
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    var task: HTTPTask {
        switch self {
        case .withoutParameters:
            return .request
        case .withURLParameter(let parameters):
            return .requestParameters(bodyParameters: nil, urlParameters: parameters)
        case .withBodyParameter(let parameters):
            return .requestParameters(bodyParameters: parameters, urlParameters: nil)
        }
    }
    
    var headers: HTTPHeaders? {
        return nil
    }    
}
