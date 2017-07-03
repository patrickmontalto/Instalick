//
//  APIClient.swift
//  Instalick
//
//  Created by Patrick Montalto on 7/1/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import Foundation
import SwiftNetworking
import JSON

final class APIClient: NetworkClient, Gettable {
    
    convenience init() {
        let url = URL(string: "http://jsonplaceholder.typicode.com/")!
        self.init(baseURL: url)
    }
    
    enum Path {
        static let photos = "photos"
    }
    
    // MARK: - Feed Items
    
    /// Get an array of feed items from the API
    ///
    /// - parameter completion: Block called with feed items if they exist
    func getArray(completion: @escaping (Result<[FeedItem]>) -> Void) {
        request(path: Path.photos, completion: completion)
    }
    
    func get(completion: @escaping (Result<FeedItem>) -> Void) {
        // TODO: Implement 
        fatalError("Not implemented")
    }

    /// Retrieve an array of JSON objects
    private func request<T: JSONDeserializable>(method: NetworkClient.Method = .get, path: String, queryItems: [URLQueryItem] = [], parameters: NetworkClient.JSONDictionary? = nil, completion: @escaping ((Result<[T]>) -> Void)) {
        
        request(method: method, path: path, queryItems: queryItems, parameters: parameters) { (result) in
            switch result {
                
            // Network Success
            case .success(_, let data):
                
                // Check for data
                guard let data = data else {
                    completion(.failure(Error.missingData))
                    return
                }
                
                // Get data as a raw JSON object
                guard let raw = try? JSONSerialization.jsonObject(with: data, options: []) else {
                    completion(.failure(Error.invalidData))
                    return
                }
                
                // Get raw data as array of JSONDictionaries
                guard let jsonArray = raw as? [JSONDictionary] else {
                    completion(.failure(Error.invalidJson))
                    return
                }
                
                // Initialize the object from the json dictionary
                let objects: [T] = jsonArray.flatMap() { try? decode($0) }
                completion(.success(objects))
                
            // Network Failure
            case .failure(let error):
                completion(.failure(error))
            }
        }

    }
    
    /// Retrieve a single JSON object
    private func request<T: JSONDeserializable>(method: NetworkClient.Method = .get, path: String, queryItems: [URLQueryItem] = [], parameters: NetworkClient.JSONDictionary? = nil, completion: @escaping ((Result<T>) -> Void)) {
        request(method: method, path: path, queryItems: queryItems, parameters: parameters) { (result) in
            switch result {
            
            // Network Success
            case .success(_, let data):
                
                // Check for data
                guard let data = data else {
                    completion(.failure(Error.missingData))
                    return
                }
                
                // Get data as a raw JSON object
                guard let raw = try? JSONSerialization.jsonObject(with: data, options: []) else {
                    completion(.failure(Error.invalidData))
                    return
                }
                
                // Get raw data as JSONDictionary
                guard let json = raw as? JSONDictionary else {
                    completion(.failure(Error.invalidJson))
                    return
                }
                
                // Initialize the object from the json dictionary
                do {
                    let object = try T(jsonRepresentation: json)
                    completion(.success(object))
                } catch {
                    completion(.failure(error))
                }
                
            // Network Failure
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
