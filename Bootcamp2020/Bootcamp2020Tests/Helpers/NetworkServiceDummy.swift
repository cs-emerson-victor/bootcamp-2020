//
//  NetworkServiceDummy.swift
//  Bootcamp2020Tests
//
//  Created by emerson.victor.f.luz on 16/03/20.
//  Copyright © 2020 Team2. All rights reserved.
//

@testable import Bootcamp2020

final class NetworkServiceDummy: NetworkService {
    func fetchCollections(completion: @escaping (Result<[Collection], Error>) -> Void) {
        
    }
    
    func fetchCards(ofCollection colletion: Collection, completion: @escaping (Result<[Card], Error>) -> Void) {
        
    }
    
    func fetchCard(withName name: String, completion: @escaping (Result<[Card], Error>) -> Void) {
        
    }
}
