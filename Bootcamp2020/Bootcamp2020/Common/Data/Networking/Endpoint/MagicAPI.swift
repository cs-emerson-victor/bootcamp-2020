//
//  MagicAPI.swift
//  Bootcamp2020
//
//  Created by jacqueline alves barbosa on 02/04/20.
//  Copyright © 2020 Team2. All rights reserved.
//

import Foundation

enum MagicAPI {
    case sets
    case cards(set: CardSet, page: Int)
    case card(name: String)
}

extension MagicAPI: EndPointType {    
    var baseURL: URL {
        guard let url = URL(string: "https://api.magicthegathering.io/v1/") else {
            fatalError("baseURL could not be configured.")
        }
        
        return url
    }
    
    var path: String {
        switch self {
        case .sets:
            return "sets"
        case .cards, .card:
            return "cards"
        }
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    var task: HTTPTask {
        switch self {
        case .cards(let set, let page):
            return .requestParameters(bodyParameters: nil,
                                      urlParameters: ["set": set.id, "page": page])
        case .card(let name):
            return .requestParameters(bodyParameters: nil,
                                      urlParameters: ["name": name])
        default:
            return .request
        }
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
}
