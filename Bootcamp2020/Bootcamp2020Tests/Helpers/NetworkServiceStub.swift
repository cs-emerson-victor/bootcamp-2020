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
    
    func fetchSets(completion: @escaping (Result<[CardSet], Error>) -> Void) {
        fetchedSets = CardSetStub().getFullSets()
        completion(.success(fetchedSets))
    }
    
    func fetchCard(withName name: String, completion: @escaping (Result<[Card], Error>) -> Void) {
        
    }
    
    func fetchCards(ofSet cardSet: CardSet, completion: @escaping (Result<[Card], Error>) -> Void) {
        fethchedCards = CardSetStub().getCardsOfSet(cardSet)
        completion(.success(fethchedCards))
    }
}
