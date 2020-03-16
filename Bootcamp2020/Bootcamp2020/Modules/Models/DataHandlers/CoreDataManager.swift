//
//  CoreDataManager.swift
//  Bootcamp2020
//
//  Created by jacqueline alves barbosa on 13/03/20.
//  Copyright © 2020 Team2. All rights reserved.
//

import Foundation
import CoreData

protocol LocalService: AnyObject, Service {
    
}

final class CoreDataManager: LocalService {
    func fetchCollections(completion: @escaping (Result<[Collection], Error>) -> Void) {
        
    }
    
    func fetchCards(ofCollection colletion: Collection, completion: @escaping (Result<[Card], Error>) -> Void) {
        
    }
    
    func fetchCard(withName name: String, completion: @escaping (Result<[Card], Error>) -> Void) {
        
    }
}
