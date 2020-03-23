//
//  Copyable.swift
//  Bootcamp2020
//
//  Created by emerson.victor.f.luz on 23/03/20.
//  Copyright © 2020 Team2. All rights reserved.
//

import Foundation

protocol Copyable: AnyObject {
    
    associatedtype Object = Self
    
    func createCopy() -> Object
}
