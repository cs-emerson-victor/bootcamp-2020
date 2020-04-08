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
    var cancelled = false
    
    override init() {}
    
    override func dataTask(with url: URL,
                           completionHandler: @escaping CompletionHandler) -> URLSessionDataTask {
        
        let data = self.data
        let response = self.response
        let error = self.error
        
        return URLSessionDataTaskMock(closure: { completionHandler(data, response, error) },
                                      cancelClosure: cancel)
    }
    
    override func dataTask(with request: URLRequest,
                           completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        
        let data = self.data
        let response = self.response
        let error = self.error
        
        return URLSessionDataTaskMock(closure: { completionHandler(data, response, error) },
                                      cancelClosure: cancel)
    }
    
    private func cancel() {
        cancelled = true
    }
}

class URLSessionDataTaskMock: URLSessionDataTask {
    private let closure: () -> Void
    private let cancelClosure: () -> Void
    
    init(closure: @escaping () -> Void, cancelClosure: @escaping () -> Void) {
        self.closure = closure
        self.cancelClosure = cancelClosure
    }
    
    override func resume() {
        closure()
    }
    
    override func cancel() {
        cancelClosure()
    }
}
