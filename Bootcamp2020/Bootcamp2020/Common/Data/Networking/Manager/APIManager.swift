//
//  APIManager.swift
//  Bootcamp2020
//
//  Created by jacqueline alves barbosa on 13/03/20.
//  Copyright © 2020 Team2. All rights reserved.
//

import Foundation

struct APIManager: Service {
    typealias HeaderFields = [AnyHashable: Any]
    
    private let networkManager: NetworkManager<MagicAPI>
    
    init(session: URLSession = .shared) {
        networkManager = NetworkManager<MagicAPI>(session: session)
    }
    
    var shouldUpdateSetsAutomatically: Bool {
        return false
    }
    
    func fetchSets(completion: @escaping (Result<[CardSet], ServiceError>) -> Void) {
        networkManager.fetch(from: .sets) { (result: Result<CardSetsResponse, ServiceError>) in
            completion(result.map { $0.sets })
        }
    }
    
    func fetchCards(withName name: String, completion: @escaping (Result<[Card], ServiceError>) -> Void) {
        networkManager.fetch(from: .card(name: name)) { (result: Result<CardsResponse, ServiceError>) in
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
            self.networkManager.fetch(from: .cards(set: cardSet, page: 1),
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
            
            networkManager.fetch(from: .cards(set: cardSet, page: page)) { (result: Result<CardsResponse, ServiceError>) in
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
