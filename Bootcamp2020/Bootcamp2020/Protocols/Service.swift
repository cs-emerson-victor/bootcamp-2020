//
//  Service.swift
//  Bootcamp2020
//
//  Created by jacqueline alves barbosa on 13/03/20.
//  Copyright © 2020 Team2. All rights reserved.
//

import Foundation

protocol CardSaverProtocol {
    
    @discardableResult
    func toggleFavorite(_ card: Card, of set: CardSet) -> Error?
    func isFavorite(_ card: Card) -> Bool
}

protocol Service {
    func fetchSets(completion: @escaping (Result<[CardSet], Error>) -> Void)
    func fetchCards(withName name: String, completion: @escaping (Result<[Card], Error>) -> Void)
    func fetchCards(ofSet cardSet: CardSet, completion: @escaping (Result<[Card], Error>) -> Void)
}

typealias LocalService = Service & CardSaverProtocol
