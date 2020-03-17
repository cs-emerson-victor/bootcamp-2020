//
//  Service.swift
//  Bootcamp2020
//
//  Created by jacqueline alves barbosa on 13/03/20.
//  Copyright © 2020 Team2. All rights reserved.
//

import Foundation

protocol Service {
    func fetchSets(completion: @escaping (Result<[CardSet], Error>) -> Void)
    func fetchCard(withName name: String, completion: @escaping (Result<[Card], Error>) -> Void)
}
