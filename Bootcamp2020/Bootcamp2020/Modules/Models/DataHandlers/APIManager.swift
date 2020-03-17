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
    
    internal func fetch<T: Codable>(from endpoint: Endpoint, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = endpoint.url else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        let task = session.dataTask(with: url) { (data, response, error) in
            if error != nil {
                completion(.failure(APIError.apiError))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                completion(.failure(APIError.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(APIError.invalidData))
                return
            }
            
            do {
                let decodedData = try self.jsonDecoder.decode(T.self, from: data)
                
                completion(.success(decodedData))
                
            } catch {
                completion(.failure(APIError.serializationError))
            }
        }
        
        task.resume()
    }
}

extension APIManager: NetworkService {
    func fetchCollections(completion: @escaping (Result<[Collection], Error>) -> Void) {
        
    }
    
    func fetchCards(ofCollection colletion: Collection, completion: @escaping (Result<[Card], Error>) -> Void) {
        let endpoint = Endpoint(ofType: .cards(collection: colletion))
        
        fetch(from: endpoint) { (result: Result<[CardDTO], Error>) in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let cardDTOList):
                let cards = cardDTOList.map { Card($0) }
                completion(.success(cards))
            }
        }
    }
    
    func fetchCard(withName name: String, completion: @escaping (Result<[Card], Error>) -> Void) {
        let endpoint = Endpoint(ofType: .card(name: name))
        
        fetch(from: endpoint) { (result: Result<[CardDTO], Error>) in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let cardDTOList):
                let cards = cardDTOList.map { Card($0) }
                completion(.success(cards))
            }
        }
    }
}
