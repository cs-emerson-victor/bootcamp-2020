//
//  RealmManager.swift
//  Bootcamp2020
//
//  Created by jacqueline alves barbosa on 13/03/20.
//  Copyright © 2020 Team2. All rights reserved.
//

import Foundation
import RealmSwift

protocol LocalService: AnyObject, Service {
    func save(_ card: Card) -> Error?
}

final class RealmManager: LocalService {
    
    private let config: Realm.Configuration
    private let realm: Realm?
    private let error: Error?
    
    init(bundleName: String = "Bootcamp2020") {
        config = Realm.Configuration(fileURL: Bundle.main.url(forResource: bundleName, withExtension: "realm"))
        do {
            self.realm = try Realm(configuration: config)
            self.error = nil
        } catch {
            self.realm = nil
            self.error = error
        }
    }
    
    func fetchCollections(completion: @escaping (Result<[Collection], Error>) -> Void) {
        guard let realm = self.realm else {
            completion(.failure(error!))
            return
        }
        
        let collections = Array(realm.objects(Collection.self).sorted(byKeyPath: "releaseDate"))
        completion(.success(collections))
    }
    
    func fetchCard(withName name: String, completion: @escaping (Result<[Card], Error>) -> Void) {
        guard let realm = self.realm else {
            completion(.failure(error!))
            return
        }
    }
    
    func save(_ card: Card) -> Error? {
//        let realm = try! Realm()
//
//        try! realm.write {
//            realm.add(myDog)
//        }
        return nil
    }
}
