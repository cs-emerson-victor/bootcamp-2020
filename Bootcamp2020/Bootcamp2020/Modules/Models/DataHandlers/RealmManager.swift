//
//  RealmManager.swift
//  Bootcamp2020
//
//  Created by jacqueline alves barbosa on 13/03/20.
//  Copyright © 2020 Team2. All rights reserved.
//

import Foundation
import RealmSwift

final class RealmManager: LocalService {
    
    let realm: Realm?
    let error: Error?
    
    init(configuration: Realm.Configuration = Realm.Configuration.defaultConfiguration) {
        do {
            self.realm = try Realm(configuration: configuration)
            self.error = nil
        } catch {
            self.realm = nil
            self.error = error
        }
    }
    
    func fetchSets(completion: @escaping (Result<[CardSet], Error>) -> Void) {
        guard let realm = self.realm else {
            completion(.failure(error!))
            return
        }
        
        let cardSets = Array(realm.objects(CardSet.self).sorted(byKeyPath: "releaseDate"))
        completion(.success(cardSets))
    }
    
    func fetchCard(withName name: String, completion: @escaping (Result<[Card], Error>) -> Void) {
        guard let realm = self.realm else {
            completion(.failure(error!))
            return
        }
        
        let cards = Array(realm.objects(Card.self).filter("name contains[c] %@", name))
        completion(.success(cards))
    }
    
    func fetchCards(ofSet cardSet: CardSet, completion: @escaping (Result<[Card], Error>) -> Void) {
        let cards = Array(cardSet.cards)
        completion(.success(cards))
    }
}

extension RealmManager {
    
    // TODO: - Refactor save and delete
    private func save(_ card: Card) -> Error? {
        card.isFavorite = true
        guard let realm = self.realm else {
            card.isFavorite = false
            return error
        }
        
        do {
            try realm.write {
                realm.add(card)
            }
            
            return nil
        } catch {
            card.isFavorite = false
            return error
        }
    }
    
    private func delete(_ card: Card) -> Error? {
        card.isFavorite = false
        guard let realm = self.realm else {
            card.isFavorite = true
            return error
        }
        
        do {
            try realm.write {
                realm.delete(card)
            }
            
            return nil
        } catch {
            card.isFavorite = true
            return error
        }
    }
    
    @discardableResult
    func toggleFavorite(_ card: Card) -> Error? {
        return card.isFavorite ? delete(card) : save(card)
    }
}
