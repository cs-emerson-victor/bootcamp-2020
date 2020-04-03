//
//  HTTPTask.swift
//  Bootcamp2020
//
//  Created by jacqueline alves barbosa on 02/04/20.
//  Copyright © 2020 Team2. All rights reserved.
//

import Foundation

public typealias HTTPHeaders = [String: String]

public enum HTTPTask {
    case request
    case requestParameters( bodyParameters: Parameters?,
                            urlParameters: Parameters?)
}
