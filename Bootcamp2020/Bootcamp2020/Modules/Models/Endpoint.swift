//
//  Endpoint.swift
//  Bootcamp2020
//
//  Created by jacqueline alves barbosa on 16/03/20.
//  Copyright © 2020 Team2. All rights reserved.
//

import Foundation

struct Endpoint {
    let baseURL = "https://api.magicthegathering.io/v1/"
    var url: URL?
    
    init(of type: EndpointType) {
        var path: String = ""
        var queryItems: [URLQueryItem]
        
        switch type {
        case .collections:
            path = "sets"
            queryItems = []
        case .cards(let collection):
            path = "cards"
            queryItems = [URLQueryItem(name: "set", value: collection.name)]
        case .card(let name):
            path = "cards"
            queryItems = [URLQueryItem(name: "name", value: name)]
        }
        
        url = getURL(withPath: path, andQueryItems: queryItems)
    }
    
    func getURL(withPath path: String, andQueryItems queryItems: [URLQueryItem]) -> URL? {
        guard var urlComponents = URLComponents(string: baseURL) else {
            return nil
        }
        
        urlComponents.path.append(contentsOf: path)
        urlComponents.queryItems = queryItems
        
        return urlComponents.url
    }
    
    enum EndpointType {
        case collections
        case cards(Collection)
        case card(String)
    }
}
