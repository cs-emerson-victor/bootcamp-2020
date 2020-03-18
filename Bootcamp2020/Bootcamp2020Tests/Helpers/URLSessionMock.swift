//
//  URLSessionMock.swift
//  Bootcamp2020Tests
//
//  Created by Jacqueline Alves on 17/03/20.
//  Copyright © 2020 Team2. All rights reserved.
//

import Foundation

class URLSessionMock: URLSession {
    typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void
    var data: Data?
    var response: URLResponse?
    var error: Error?

    override func dataTask(with url: URL,
                           completionHandler: @escaping CompletionHandler) -> URLSessionDataTask {
        
        let data = self.data
        let response = self.response
        let error = self.error

        return URLSessionDataTaskMock {
            completionHandler(data, response, error)
        }
    }
}

class URLSessionDataTaskMock: URLSessionDataTask {
    private let closure: () -> Void

    init(closure: @escaping () -> Void) {
        self.closure = closure
    }
    
    override func resume() {
        closure()
    }
}
