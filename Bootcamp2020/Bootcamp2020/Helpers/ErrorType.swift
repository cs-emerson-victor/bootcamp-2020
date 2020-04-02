//
//  ErrorType.swift
//  Bootcamp2020
//
//  Created by alexandre.c.ferreira on 24/03/20.
//  Copyright © 2020 Team2. All rights reserved.
//

import UIKit

enum ErrorType: Equatable {
    
    /// Display a generic error message.
    case generic
    
    /// Inform that the user has no internet access.
    case noInternet
    
    /// Inform the user the API had an error.
    case api
    
    /// Inform that the user search was empty.
    case emptySearch(_ searchedText: String)
    
    /// When card list is empty
    case emptyList
}

extension ErrorType {
    
    var message: String {
        switch self {
        case .api:
            return "Sorry, we had an internal problem. Please try again later."
        case .emptySearch(let searchedText):
            return "Sorry, we couldn't find any card with name \"\(searchedText)\"."
        case .generic:
            return "Ops, an error occurred. Please try again later."
        case .noInternet:
            return "It looks like you're not connected to the internet. Please connect and try again."
        case .emptyList:
            return "You don't have any favorite cards yet.\nHow about adding some?"
        }
    }
    
    var image: UIImage {
        switch self {
        case .api, .generic, .emptyList:
            return #imageLiteral(resourceName: "error")
        case .noInternet:
            return #imageLiteral(resourceName: "internetError")
        case .emptySearch:
            return #imageLiteral(resourceName: "emptySearch")
        }
    }
}
