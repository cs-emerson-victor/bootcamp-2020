//
//  LocalServiceDummy.swift
//  Bootcamp2020Tests
//
//  Created by emerson.victor.f.luz on 16/03/20.
//  Copyright © 2020 Team2. All rights reserved.
//

@testable import Bootcamp2020

final class LocalServiceDummy: LocalService {
    func save(_ card: Card) -> Error? {
        return nil
    }
    
    func fetchCard(withName name: String, completion: @escaping (Result<[Card], Error>) -> Void) {
        
    }
    
    func fetchSets(completion: @escaping (Result<[CardSet], Error>) -> Void) {
        
    }
}