//
//  APIManager.swift
//  Bootcamp2020
//
//  Created by jacqueline alves barbosa on 13/03/20.
//  Copyright © 2020 Team2. All rights reserved.
//

import Foundation

struct APIManager {
    typealias EndPoint = MagicAPI
    typealias Completion<T: Codable> = (Result<T, ServiceError>) -> Void
    typealias HeaderFields = [AnyHashable: Any]
    
    private let router: Router<MagicAPI>
    
    init(session: URLSession = .shared) {
        router = Router<MagicAPI>(session: session)
    }
    
    enum NetworkError: String, Error {
        case success
        case badRequest = "Bad request."
        case forbidden = "You exceeded the rate limit."
        case notFound = "The requested resource could not be found."
        case internalServerError = "We had a problem with our server. Please try again later."
        case serviceUnavailable = "We are temporarily offline for maintenance. Please try again later."
        case failed = "Network request failed."
        case noData = "Response returned with no data to decode."
        case unableToDecode = "We could not decode the response."
    }
    
    fileprivate func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<String, NetworkError> {
        switch response.statusCode {
        case 200...299: return .success("Success")
        case 400: return .failure(.badRequest)
        case 403: return .failure(.forbidden)
        case 404: return .failure(.notFound)
        case 500: return .failure(.internalServerError)
        case 503: return .failure(.serviceUnavailable)
        default: return .failure(.failed)
        }
    }
    
    private func fetch<T: Codable>( from endpoint: EndPoint,
                                    completion: @escaping Completion<T>) {
        
        //TODO: Place somewhere else
        //        guard Reachability.shared.currentStatus == .reachable else {
        //            completion(.failure(.networkError))
        //            return
        //        }
        
        router.request(endpoint) { (data, response, error) in
            self.decodeCompletion(data: data, response: response, error: error) { (result: Result<T, ServiceError>) in
                completion(result)
            }
        }
    }
    
    private func fetch<T: Codable>( from endpoint: EndPoint,
                                    returningHeaderFields headerFields: [AnyHashable],
                                    completion: @escaping (_ result: Result<(data: T, fields: HeaderFields), ServiceError>) -> Void) {
        
        //TODO: Place somewhere else
        //        guard Reachability.shared.currentStatus == .reachable else {
        //            completion(.failure(.networkError))
        //            return
        //        }
        
        router.request(endpoint) { (data, response, error) in
            self.decodeCompletion(data: data, response: response, error: error) { (result: Result<T, ServiceError>) in
                var fields: [AnyHashable: Any] = [:]
                if let httpResponse = response as? HTTPURLResponse {
                    fields = self.filterHeaderFields(httpResponse.allHeaderFields, withKeys: headerFields)
                }
                
                completion(result.map { (data: $0, fields: fields) })
            }
        }
        
    }
    
    internal func filterHeaderFields(_ fields: [AnyHashable: Any], withKeys: [AnyHashable]) -> [AnyHashable: Any] {
        return fields.filter { field -> Bool in
            return withKeys.contains(field.key)
        }
    }
    
    private func decodeCompletion<T: Codable>( data: Data?,
                                               response: URLResponse?,
                                               error: Error?,
                                               completion: @escaping Completion<T>) {
        
        guard error == nil, let response = response as? HTTPURLResponse, let data = data else {
            completion(.failure(.apiError))
            return
        }
        
        let result = handleNetworkResponse(response)
        
        switch result {
        case .success:
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedData))
                
            } catch {
                completion(.failure(.apiError))
            }
        default:
            completion(.failure(.apiError))
        }
    }
}

// MARK: - Network Service

extension APIManager: Service {
    var shouldUpdateSetsAutomatically: Bool {
        return false
    }
    
    func fetchSets(completion: @escaping (Result<[CardSet], ServiceError>) -> Void) {
        fetch(from: .sets) { (result: Result<CardSetsResponse, ServiceError>) in
            completion(result.map { $0.sets })
        }
    }
    
    func fetchCards(withName name: String, completion: @escaping (Result<[Card], ServiceError>) -> Void) {
        fetch(from: .card(name: name)) { (result: Result<CardsResponse, ServiceError>) in
            completion(result.map { $0.cards })
        }
    }
    
    func fetchCards(ofSet cardSet: CardSet, completion: @escaping (Result<[Card], ServiceError>) -> Void) {
        let backgroundQueue = DispatchQueue.global(qos: .background)
        let dispatchGroup = DispatchGroup()
        var allCards = [Card]()
        var pages = 0
        let totalCountField: AnyHashable = "total-count"
        
        dispatchGroup.enter()
        backgroundQueue.async {
            // Fetch first page and get page count
            self.fetch(from: .cards(set: cardSet, page: 1),
                       returningHeaderFields: [totalCountField]) { (result: Result<(data: CardsResponse, fields: HeaderFields), ServiceError>) in
                        
                        switch result {
                        case .failure(let error):
                            completion(.failure(error))
                        case .success(let response):
                            if let totalCardCountString = response.fields[totalCountField] as? String,
                                let totalCardCount = Int(totalCardCountString) {
                                let pageCount = Int(ceil(Double(totalCardCount)/100))
                                
                                allCards.append(contentsOf: response.data.cards)
                                pages = pageCount
                            } else {
                                completion(.failure(.apiError))
                            }
                        }
                        
                        dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: backgroundQueue) {
            self.fetchPages(pages, ofCardsFromSet: cardSet) { result in
                switch result {
                case .failure(let error):
                    completion(.failure(error))
                case .success(let cards):
                    allCards.append(contentsOf: cards)
                    completion(.success(allCards))
                }
            }
        }
    }
}

// MARK: - Fetch Card by name

extension APIManager {
    private func fetchPages(_ pageCount: Int,
                            ofCardsFromSet cardSet: CardSet,
                            completion: @escaping (Result<[Card], ServiceError>) -> Void) {
        
        guard pageCount > 1 else {
            completion(.success([]))
            return
        }
        
        let dispatchGroup = DispatchGroup()
        var allCards = [Card]()
        var anyError: ServiceError?
        
        for page in 2...pageCount {
            dispatchGroup.enter()
            
            fetch(from: .cards(set: cardSet, page: page)) { (result: Result<CardsResponse, ServiceError>) in
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
