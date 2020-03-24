//
//  ErrorType.swift
//  Bootcamp2020
//
//  Created by alexandre.c.ferreira on 24/03/20.
//  Copyright © 2020 Team2. All rights reserved.
//

import Foundation

enum ErrorType {
    
    /// Display a generic error message.
    case generic
    
    /// Inform that the user has no internet access.
    case noInternet
    
    /// Inform the user the API had an error.
    case api(_ message: String)
    
    /// Inform that the user search was empty.
    case emptySearch(_ searchedText: String)
}
