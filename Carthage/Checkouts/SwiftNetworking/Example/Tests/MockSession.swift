//
//  MockSession.swift
//  SwiftNetworking
//
//  Created by Patrick on 4/5/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
import SwiftNetworking

/// Only data tasks with a callback are supported.
final class MockSession: URLSession {
    
    // MARK: - Types
    
    typealias Interaction = (URLRequest, NetworkResult)
    typealias Handler = (URLRequest) -> (NetworkResult)
    
    private final class Task: URLSessionDataTask {
        let completion: (Void) -> Void
        
        init(completion: @escaping (Void) -> Void) {
            self.completion = completion
            super.init()
        }
        
        override func resume() {
            completion()
        }
    }
    
    // MARK: - Parameters
    
    /// Received requests
    private(set) var requests = [URLRequest]()
    
    // Completed request, response pairs
    private(set) var interactions = [Interaction]()
    private let handler: Handler
    
    // MARK: - Initializers
    
    init(handler: @escaping Handler) {
        self.handler = handler
        super.init()
    }
    
    // MARK: - URLSession
    override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return Task(completion: {
            let result = self.handler(request)
            self.interactions.append((request, result))

            switch result {
            case .success(let response, let data):
                completionHandler(data, response, nil)
            case .failure(let error):
                completionHandler(nil, nil, error)
            }
        })
    }
}
