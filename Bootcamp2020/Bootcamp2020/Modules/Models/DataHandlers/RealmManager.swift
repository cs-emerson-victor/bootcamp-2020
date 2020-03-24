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
    
    let realm: Realm
    
    init(configuration: Realm.Configuration = Realm.Configuration.defaultConfiguration) throws {
        do {
            self.realm = try Realm(configuration: configuration)
        } catch {
            throw error
        }
    }
    
    func fetchSets(completion: @escaping (Result<[CardSet], ServiceError>) -> Void) {
        let cardSets = Array(realm.objects(CardSet.self).sorted(byKeyPath: "releaseDate"))
        completion(.success(cardSets))
    }
    
    func fetchCards(withName name: String, completion: @escaping (Result<[Card], ServiceError>) -> Void) {
        let cards = Array(realm.objects(Card.self).filter("name contains[c] %@", name))
        completion(.success(cards))
    }
    
    func fetchCards(ofSet cardSet: CardSet, completion: @escaping (Result<[Card], ServiceError>) -> Void) {
        let cards = Array(cardSet.cards)
        completion(.success(cards))
    }
}

extension RealmManager {
    
    private func save(_ card: Card, of set: CardSet) -> Error? {
        do {
            if let realmSet = realm.object(ofType: CardSet.self, forPrimaryKey: set.id) {
                let realmCard = realm.object(ofType: Card.self, forPrimaryKey: card.id)
                
                try realm.write {
                    if realmCard == nil {
                        realmSet.cards.append(card.createCopy())
                    }
                }
            } else {
                let setCopy = set.createCopy()
                setCopy.cards.removeAll()
                
                try realm.write {
                    realm.add(setCopy)
                    setCopy.cards.append(card.createCopy())
                }
            }
            
            return nil
        } catch {
            return error
        }
    }
    
    private func delete(_ card: Card, of set: CardSet) -> Error? {
        do {
            if let realmSet = realm.object(ofType: CardSet.self, forPrimaryKey: set.id),
                let realmCard = realm.object(ofType: Card.self, forPrimaryKey: card.id) {
                
                try realm.write {
                    realm.delete(realmCard)
                    if realmSet.cards.count == 0 {
                        realm.delete(realmSet)
                    }
                }
            }
            
            return nil
        } catch {
            return error
        }
    }
    
    @discardableResult
    func toggleFavorite(_ card: Card, of set: CardSet) -> Error? {
        return card.isFavorite ? save(card, of: set) : delete(card, of: set)
    }
    
    func isFavorite(_ card: Card) -> Bool {
        let card = realm.object(ofType: Card.self, forPrimaryKey: card.id)
        return card == nil ? false : true
    }
}
