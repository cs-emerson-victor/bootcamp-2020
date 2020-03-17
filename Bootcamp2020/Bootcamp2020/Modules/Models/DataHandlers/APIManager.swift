//
//  APIManager.swift
//  Bootcamp2020
//
//  Created by jacqueline alves barbosa on 13/03/20.
//  Copyright © 2020 Team2. All rights reserved.
//

import Foundation

protocol NetworkService: AnyObject, Service {
    func fetchCards(ofCollection colletion: CardSet, completion: @escaping (Result<[Card], Error>) -> Void)
}

final class APIManager: NetworkService {
    func fetchCards(ofCollection colletion: CardSet, completion: @escaping (Result<[Card], Error>) -> Void) {
        
    }
    
    func fetchCard(withName name: String, completion: @escaping (Result<[Card], Error>) -> Void) {
        
    }
    
    func fetchSets(completion: @escaping (Result<[CardSet], Error>) -> Void) {
        
    }
}
