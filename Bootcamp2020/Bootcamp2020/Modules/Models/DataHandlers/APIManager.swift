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
        
        request(from: endpoint.url, withParams: params) { (data, _, error) in
            if let error = error {
                completion(.failure(error))
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
    }
    
    internal func fetch<T: Codable>(from endpoint: Endpoint,
                                    withParams params: Params? = nil,
                                    returningHeaderFields headerFields: [String],
                                    completion: @escaping (_ result: Result<(data: T, fields: HeaderFields), Error>) -> Void) {
        
        request(from: endpoint.url, withParams: params) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(APIError.invalidData))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(APIError.invalidResponse))
                return
            }
            
            do {
                let decodedData = try self.jsonDecoder.decode(T.self, from: data)
                let fields = httpResponse.allHeaderFields.filter { field -> Bool in
                    guard let key  = field.key as? String else { return false }
                    return headerFields.contains(key)
                }
                
                completion(.success((data: decodedData, fields: fields)))
            } catch {
                completion(.failure(APIError.serializationError))
            }
        }
        
    }
    
    internal func request(from url: URL?,
                          withParams params: Params?,
                          completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        
        guard let url = composeURL(url, withParams: params) else {
            completion(nil, nil, APIError.invalidURL)
            return
        }
        
        let task = session.dataTask(with: url) { (data, response, error) in
            completion(data, response, error)
        }
        
        task.resume()
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

extension APIManager: NetworkService {
    func fetchCollections(completion: @escaping (Result<[Collection], Error>) -> Void) {
        let endpoint = Endpoint(ofType: .collections)
        
        fetch(from: endpoint) { (result: Result<CollectionsResponse, Error>) in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let response):
                completion(.success(response.sets))
            }
        }
    }
    
    func fetchCards(ofCollection colletion: Collection,
                    completion: @escaping (Result<[Card], Error>) -> Void) {
        
        let dispatchGroup = DispatchGroup()
        let endpoint = Endpoint(ofType: .cards(collection: colletion))
        var allCards = [Card]()
        var maxPages = 0
                
        dispatchGroup.enter()
        
        fetchFirstPage(endpoint) { (result: Result<(cards: [Card], pages: Int), Error>) in
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
        
        fetchPages(endpoint, maxPages) { result in
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
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let response):
                completion(.success(response.cards))
            }
        }
    }
}

extension APIManager {
    private func fetchFirstPage(_ endpoint: Endpoint,
                                completion: @escaping (Result<(cards: [Card], pages: Int), Error>) -> Void) {
         
         var pageCount = 0
         let pageCountFieldKey = "total-count"
         
         fetch(from: endpoint,
               withParams: ["page": "1"],
               returningHeaderFields: [pageCountFieldKey]) { (result: Result<(data: CardsResponse, fields: HeaderFields), Error>) in
                 
                 switch result {
                 case .failure(let error):
                     completion(.failure(error))
                 case .success(let response):
                     if let totalCardCountString = response.fields[pageCountFieldKey] as? String,
                        let totalCardCount = Int(totalCardCountString) {
                        
                         pageCount = Int(ceil(Double(totalCardCount)/100))
                     }
                     
                     completion(.success((cards: response.data.cards, pages: pageCount)))
                 }
         }
     }
     
     private func fetchPages(_ endpoint: Endpoint,
                             _ pageCount: Int,
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
                     dispatchGroup.leave()
                 case .success(let response):
                     allCards.append(contentsOf: response.cards)
                 }
                 
                 dispatchGroup.leave()
             }
             
             if let error = anyError {
                 completion(.failure(error))
                 return
             }
         }
         
         dispatchGroup.notify(queue: .main) {
             completion(.success(allCards))
         }
     }
}
