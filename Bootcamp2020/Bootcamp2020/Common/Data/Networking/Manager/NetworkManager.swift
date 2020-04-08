//
//  NetworkManager.swift
//  Bootcamp2020
//
//  Created by jacqueline alves barbosa on 08/04/20.
//  Copyright © 2020 Team2. All rights reserved.
//

import Foundation

struct NetworkManager<EndPoint: EndPointType> {
    typealias Completion<T: Codable> = (Result<T, ServiceError>) -> Void
    typealias HeaderFields = [AnyHashable: Any]
    
    private let router: Router<EndPoint>
    
    init(session: URLSession = .shared) {
        router = Router<EndPoint>(session: session)
    }
    
    enum NetworkError: String, Error {
        case success
        case badRequest = "Bad request."
        case forbidden = "You exceeded the rate limit."
        case notFound = "The requested resource could not be found."
        case internalServerError = "We had a problem with our server. Please try again later."
        case serviceUnavailable = "We are temporarily offline for maintenance. Please try again later."
        case failed = "Network request failed."
        case noData = "Response returned with no data to decode."
        case unableToDecode = "We could not decode the response."
    }
    
    internal func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<String, NetworkError> {
        switch response.statusCode {
        case 200...299: return .success("Success")
        case 400: return .failure(.badRequest)
        case 403: return .failure(.forbidden)
        case 404: return .failure(.notFound)
        case 500: return .failure(.internalServerError)
        case 503: return .failure(.serviceUnavailable)
        default: return .failure(.failed)
        }
    }
    
    func fetch<T: Codable>( from endpoint: EndPoint,
                            completion: @escaping Completion<T>) {
        
        router.request(endpoint) { (data, response, error) in
            self.decodeCompletion(data: data, response: response, error: error) { (result: Result<T, ServiceError>) in
                completion(result)
            }
        }
    }
    
    func fetch<T: Codable>( from endpoint: EndPoint,
                            returningHeaderFields headerFields: [AnyHashable],
                            completion: @escaping (_ result: Result<(data: T, fields: HeaderFields), ServiceError>) -> Void) {
        
        router.request(endpoint) { (data, response, error) in
            self.decodeCompletion(data: data, response: response, error: error) { (result: Result<T, ServiceError>) in
                var fields: [AnyHashable: Any] = [:]
                if let httpResponse = response as? HTTPURLResponse {
                    fields = self.filterHeaderFields(httpResponse.allHeaderFields, withKeys: headerFields)
                }
                
                completion(result.map { (data: $0, fields: fields) })
            }
        }
        
    }
    
    private func filterHeaderFields(_ fields: [AnyHashable: Any], withKeys: [AnyHashable]) -> [AnyHashable: Any] {
        return fields.filter { field -> Bool in
            return withKeys.contains(field.key)
        }
    }
    
    internal func decodeCompletion<T: Codable>(data: Data?,
                                               response: URLResponse?,
                                               error: Error?,
                                               completion: @escaping Completion<T>) {
        
        guard error == nil, let response = response as? HTTPURLResponse, let data = data else {
            completion(.failure(.apiError))
            return
        }
        
        let result = handleNetworkResponse(response)
        
        switch result {
        case .success:
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedData))
                
            } catch {
                completion(.failure(.apiError))
            }
        default:
            completion(.failure(.apiError))
        }
    }
}
