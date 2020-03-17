//
//  APIManager.swift
//  Bootcamp2020
//
//  Created by jacqueline alves barbosa on 13/03/20.
//  Copyright © 2020 Team2. All rights reserved.
//

import Foundation

// TODO: Refactor Collection name

enum APIError: Error {
    case invalidURL
    case defaultError
    case serializationError
}

class CardsResponse: Codable {
    var cards: [Card]
    
    init(cards: [Card]) {
        self.cards = cards
    }
}

class CollectionsResponse: Codable {
    var sets: [Collection]
}

protocol NetworkService: Service {}

class APIManager {
    typealias HeaderFields = [AnyHashable: Any]
    typealias Params = [String: String]
    
    private let session: URLSession
    private let baseURL: String = "https://api.magicthegathering.io/v1"
    private let jsonDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        
        return jsonDecoder
    }()
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    internal func fetch<T: Codable>(from endpoint: Endpoint,
                                    withParams params: Params? = nil,
                                    completion: @escaping (Result<T, Error>) -> Void) {
        
        guard let url = composeURL(endpoint.url, withParams: params) else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        let task = session.dataTask(with: url) { (data, _, error) in
            guard let data = data, error == nil else {
                completion(.failure(error ?? APIError.defaultError))
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
    
    internal func fetch<T: Codable>(from endpoint: Endpoint,
                                    withParams params: Params? = nil,
                                    returningHeaderFields headerFields: [String],
                                    completion: @escaping (_ result: Result<(data: T, fields: HeaderFields), Error>) -> Void) {
        
        guard let url = composeURL(endpoint.url, withParams: params) else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        let task = session.dataTask(with: url) { (data, response, error) in
            guard let httpResponse = response as? HTTPURLResponse, let data = data, error == nil else {
                completion(.failure(error ?? APIError.defaultError))
                return
            }
            
            do {
                let decodedData = try self.jsonDecoder.decode(T.self, from: data)
                let fields = self.filterHeaderFields(httpResponse.allHeaderFields, withKeys: headerFields)
                
                completion(.success((data: decodedData, fields: fields)))
            } catch {
                completion(.failure(APIError.serializationError))
            }
        }
        
        task.resume()
    }
    
    internal func filterHeaderFields(_ fields: [AnyHashable: Any], withKeys: [String]) -> [AnyHashable: Any] {
        return fields.filter { field -> Bool in
            guard let key  = field.key as? String else { return false }
            return withKeys.contains(key)
        }
    }
    
    internal func composeURL(_ url: URL?, withParams params: Params?) -> URL? {
        guard let url = url else { return nil }
        guard let params = params else { return url }
        
        var urlComponents = URLComponents(string: url.absoluteString)
        let queryItems = params.map { URLQueryItem(name: $0.key, value: $0.value) }
        
        urlComponents?.queryItems?.append(contentsOf: queryItems)
        
        return urlComponents?.url
    }
}

// MARK: - Network Service

extension APIManager: NetworkService {
    func fetchCollections(completion: @escaping (Result<[Collection], Error>) -> Void) {
        let endpoint = Endpoint(ofType: .collections)
        
        fetch(from: endpoint) { (result: Result<CollectionsResponse, Error>) in
            completion(result.map { $0.sets })
        }
    }
    
    func fetchCards(ofCollection colletion: Collection,
                    completion: @escaping (Result<[Card], Error>) -> Void) {
        
        let dispatchGroup = DispatchGroup()
        let endpoint = Endpoint(ofType: .cards(collection: colletion))
        var allCards = [Card]()
        var maxPages = 0
        
        dispatchGroup.enter()
        
        fetchFirstPage(from: endpoint) { (result: Result<(cards: [Card], pages: Int), Error>) in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let response):
                allCards.append(contentsOf: response.cards)
                maxPages = response.pages
            }
            
            dispatchGroup.leave()
        }
        
        dispatchGroup.wait()
        
        fetchPages(from: endpoint, pageCount: maxPages) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let cards):
                allCards.append(contentsOf: cards)
                completion(.success(allCards))
            }
        }
    }
    
    func fetchCard(withName name: String,
                   completion: @escaping (Result<[Card], Error>) -> Void) {
        
        let endpoint = Endpoint(ofType: .card(name: name))
        
        fetch(from: endpoint) { (result: Result<CardsResponse, Error>) in
            completion(result.map { $0.cards })
        }
    }
}

// MARK: - Fetch Card by name

extension APIManager {
    private func fetchFirstPage(from endpoint: Endpoint,
                                completion: @escaping (Result<(cards: [Card], pages: Int), Error>) -> Void) {
        
        let fieldsToRecover = ["total-count"]
        
        fetch(from: endpoint,
              withParams: ["page": "1"],
              returningHeaderFields: fieldsToRecover) { (result: Result<(data: CardsResponse, fields: HeaderFields), Error>) in
                
                switch result {
                case .failure(let error):
                    completion(.failure(error))
                case .success(let response):
                    if let totalCardCountString = response.fields[fieldsToRecover] as? String,
                        let totalCardCount = Int(totalCardCountString) {
                        let pageCount = Int(ceil(Double(totalCardCount)/100))
                        
                         completion(.success((cards: response.data.cards, pages: pageCount)))
                    } else {
                        completion(.failure(APIError.defaultError))
                    }
                }
        }
    }
    
    private func fetchPages(from endpoint: Endpoint,
                            pageCount: Int,
                            completion: @escaping (Result<[Card], Error>) -> Void) {
        
        let dispatchGroup = DispatchGroup()
        var allCards = [Card]()
        var anyError: Error?
        
        for page in 2..<(pageCount + 1) {
            dispatchGroup.enter()
            
            fetch(from: endpoint, withParams: ["page": "\(page)"]) { (result: Result<CardsResponse, Error>) in
                switch result {
                case .failure(let error):
                    anyError = error
                    dispatchGroup.suspend()
                case .success(let response):
                    allCards.append(contentsOf: response.cards)
                }
                
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            if let error = anyError {
                completion(.failure(error))
            } else {
                completion(.success(allCards))
            }
        }
    }
}
