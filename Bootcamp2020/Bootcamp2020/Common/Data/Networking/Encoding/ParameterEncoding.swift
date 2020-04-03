//
//  ParameterEncoding.swift
//  Bootcamp2020
//
//  Created by jacqueline alves barbosa on 02/04/20.
//  Copyright © 2020 Team2. All rights reserved.
//

import Foundation

public typealias Parameters = [String: Any]

public enum NetworkError: String, Error {
    case parametersNil = "Parameters were nil."
    case encodingFailed = "Parameter encoding failed."
    case missingURL = "URL is nil."
}

public protocol ParameterEncoder {
    static func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws
}
