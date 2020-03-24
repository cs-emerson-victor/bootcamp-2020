//
//  ErrorType.swift
//  Bootcamp2020
//
//  Created by alexandre.c.ferreira on 24/03/20.
//  Copyright © 2020 Team2. All rights reserved.
//

import Foundation

enum ErrorType: Equatable {
    
    /// Display a generic error message.
    case generic
    
    /// Inform that the user has no internet access.
    case noInternet
    
    /// Inform the user the API had an error.
    case api(_ message: String)
    
    /// Inform that the user search was empty.
    case emptySearch(_ searchedText: String)
}

extension ErrorType {
    
    var message: String {
        switch self {
        case .api(let message):
            return "Error: The server had a problem\n\(message)"
        case .emptySearch(let searchedText):
            return "Your search of \"\(searchedText)\" found nothing"
        case .generic:
            return "Error: something went wrong.\nPlease try again later."
        case .noInternet:
            return "Error: no internet connection.\nPlease check your connection."
        }
    }
}
