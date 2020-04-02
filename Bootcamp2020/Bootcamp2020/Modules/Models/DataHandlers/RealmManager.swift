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
    
    var shouldUpdateSetsAutomatically: Bool {
        return true
    }
    
    func fetchSets(completion: @escaping (Result<[CardSet], ServiceError>) -> Void) {
        let realmCardSets = Array(realm.objects(RealmCardSet.self).sorted(byKeyPath: "releaseDate"))
        
        let cardSets = realmCardSets.map { (realmSet) -> CardSet in
            CardSet(set: realmSet)
        }
        
        completion(.success(cardSets))
    }
    
    func fetchCards(withName name: String, completion: @escaping (Result<[Card], ServiceError>) -> Void) {
        let realmCards = Array(realm.objects(RealmCard.self).filter("name contains[c] %@", name))
        
        let cards = realmCards.map { (realmCard) -> Card in
            return Card(card: realmCard)
        }
        
        completion(.success(cards))
    }
    
    func fetchCards(ofSet cardSet: CardSet, completion: @escaping (Result<[Card], ServiceError>) -> Void) {
        completion(.success(cardSet.cards))
    }
}

extension RealmManager {
    
    private func save(_ card: Card, of set: CardSet) -> Error? {
        do {
            if realm.object(ofType: RealmCard.self, forPrimaryKey: card.id) != nil {
                return nil
            }
            
            let realmCard = RealmCard(card: card)
            if let realmSet = realm.object(ofType: RealmCardSet.self, forPrimaryKey: set.id) {
                try realm.write {
                    realmSet.cards.append(realmCard)
                }
                
            } else {
                let realmSet = RealmCardSet(set: set)
                try realm.write {
                    realm.add(realmSet)
                    realmSet.cards.append(realmCard)
                }
            }
            
            return nil
        } catch {
            return error
        }
    }
    
    private func delete(_ card: Card, of set: CardSet) -> Error? {
        do {
            if let realmSet = realm.object(ofType: RealmCardSet.self, forPrimaryKey: set.id),
                let realmCard = realm.object(ofType: RealmCard.self, forPrimaryKey: card.id) {
                
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
        let realmCard = realm.object(ofType: RealmCard.self, forPrimaryKey: card.id)

        if realmCard == nil {
            card.isFavorite = false
        } else {
            card.isFavorite = true
        }

        return card.isFavorite
    }
}
