//
//  NetworkRouter.swift
//  Bootcamp2020
//
//  Created by jacqueline alves barbosa on 02/04/20.
//  Copyright © 2020 Team2. All rights reserved.
//

import Foundation

public typealias NetworkRouterCompletion = (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void

protocol NetworkRouter: class {
    associatedtype EndPoint: EndPointType
    
    func request(_ route: EndPoint, completion: @escaping NetworkRouterCompletion)
    func cancel()
}
