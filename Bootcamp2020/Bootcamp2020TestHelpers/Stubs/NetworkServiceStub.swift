//
//  NetworkServiceStub.swift
//  Bootcamp2020Tests
//
//  Created by alexandre.c.ferreira on 17/03/20.
//  Copyright © 2020 Team2. All rights reserved.
//

@testable import Bootcamp2020

final class NetworkServiceStub: Service {
    
    var fetchedSets: [CardSet] = []
    var fethchedCards: [Card] = []
    
    var shouldUpdateSetsAutomatically: Bool = false
    
    func fetchSets(completion: @escaping (Result<[CardSet], ServiceError>) -> Void) {
        fetchedSets = CardSetStub().getFullSets()
        completion(.success(fetchedSets))
    }
    
    func fetchCards(withName name: String, completion: @escaping (Result<[Card], ServiceError>) -> Void) {
        
        if name.isEmpty {
            completion(.success([]))
        } else {
            let card = Card(id: "0", name: name, cardSetID: "0")
            completion(.success([card]))
        }
    }
    
    func fetchCards(ofSet cardSet: CardSet, completion: @escaping (Result<[Card], ServiceError>) -> Void) {
        fethchedCards = CardSetStub().getCardsOfSet(cardSet)
        completion(.success(fethchedCards))
    }
}
