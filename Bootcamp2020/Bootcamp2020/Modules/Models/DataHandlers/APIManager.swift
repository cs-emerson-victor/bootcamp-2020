//
//  APIManager.swift
//  Bootcamp2020
//
//  Created by jacqueline alves barbosa on 13/03/20.
//  Copyright © 2020 Team2. All rights reserved.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case apiError
    case invalidResponse
    case invalidData
    case serializationError
}

protocol NetworkService: Service {}

class APIManager {
    private let session: URLSession
    private let baseURL: String = "https://api.magicthegathering.io/v1"
    private let jsonDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        
        return jsonDecoder
    }()
    
    init(session: URLSession) {
        self.session = session
    }
    
    internal func fetch<T: Codable>(from endpoint: Endpoint, completion: @escaping (Result<T, APIError>) -> Void) {
        guard let url = endpoint.url else {
            completion(.failure(.invalidURL))
            return
        }
        
        let task = session.dataTask(with: url) { (data, response, error) in
            if error != nil {
                completion(.failure(.apiError))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            do {
                let decodedData = try self.jsonDecoder.decode(T.self, from: data)
                
                completion(.success(decodedData))
                
            } catch {
                completion(.failure(.serializationError))
            }
        }
        
        task.resume()
    }
}

extension APIManager: NetworkService {
    func fetchCollections(completion: @escaping (Result<[Collection], Error>) -> Void) {
        
    }
    
    func fetchCards(ofCollection colletion: Collection, completion: @escaping (Result<[Card], Error>) -> Void) {
        
    }
    
    func fetchCard(withName name: String, completion: @escaping (Result<[Card], Error>) -> Void) {
        
    }
}
