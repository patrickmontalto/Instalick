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
import Reachability

/// The concrete implementation of `NetworkClient` which is responsible for retrieving data from the API.
final class APIClient: NetworkClient, Gettable {
    
    // MARK: - Properties
    
    /// The custom `URLCache` used to persist data from the API.
    private static var urlCache: URLCache = {
        let cacheSizeMemory = 500*1024*1024
        let cacheSizeDisk = 500*1024*1024
        let cache = URLCache(memoryCapacity: cacheSizeMemory, diskCapacity: cacheSizeDisk, diskPath: String(describing: URLCache.self))
        return cache
    }()
    
    /// The custom `URLSessionConfiguration` which designates caching policy and timeout intervals.
    private static var urlSessionConfig: URLSessionConfiguration = {
        let config = URLSessionConfiguration.default
        config.urlCache = APIClient.urlCache
        config.requestCachePolicy = .reloadRevalidatingCacheData
        config.timeoutIntervalForRequest = 10.0
        config.timeoutIntervalForResource = 60.0
        return config
    }()

    
    // MARK: - Initializer
    
    convenience init() {
        let url = URL(string: "http://jsonplaceholder.typicode.com/")!
        let session = URLSession(configuration: APIClient.urlSessionConfig)
        self.init(baseURL: url, session: session)
    }
    
    enum Path {
        static let photos = "photos"
    }
    
    // MARK: - Feed Items
    
    /// Get an array of feed items from the API.
    ///
    /// - parameter completion: Block called with feed items GET request result.
    func getArray(completion: @escaping (Result<[FeedItem]>) -> Void) {
        request(path: Path.photos, completion: completion)
    }
    
    /// Get a single feed item from the API.
    ///
    /// - parameter completion: Block called with feed item GET request result.
    func get(completion: @escaping (Result<FeedItem>) -> Void) {
        // TODO: Implement 
        fatalError("Not implemented")
    }
    
    /// Get the cached data for the last feed items if it exists.
    func cachedFeedItems() -> [FeedItem]? {
        let request = buildRequest(path: Path.photos)
        if let cachedResponse = APIClient.urlCache.cachedResponse(for: request) {
            // Get data as array of JSONDictionary
            guard let raw = try? JSONSerialization.jsonObject(with: cachedResponse.data, options: []),
                let jsonArray = raw as? [JSONDictionary] else {
                    return nil
            }
            
            // Initialize the objects from the json dictionary
            let objects: [FeedItem] = jsonArray.flatMap() { try? decode($0) }
            return objects
        } else { return nil }
    }
    
    // MARK: - Requests

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
