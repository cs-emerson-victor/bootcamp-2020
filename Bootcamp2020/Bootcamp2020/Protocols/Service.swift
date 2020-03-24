//
//  Service.swift
//  Bootcamp2020
//
//  Created by jacqueline alves barbosa on 13/03/20.
//  Copyright © 2020 Team2. All rights reserved.
//

import Foundation

enum ServiceError: Error {
    case networkError
    case emptySearch
    case apiError
    case defaultError
}

protocol CardSaverProtocol {
    
    @discardableResult
    func toggleFavorite(_ card: Card, of set: CardSet) -> Error?
    func isFavorite(_ card: Card) -> Bool
}

protocol Service {
    func fetchSets(completion: @escaping (Result<[CardSet], ServiceError>) -> Void)
    func fetchCards(withName name: String, completion: @escaping (Result<[Card], ServiceError>) -> Void)
    func fetchCards(ofSet cardSet: CardSet, completion: @escaping (Result<[Card], ServiceError>) -> Void)
}

typealias LocalService = Service & CardSaverProtocol
