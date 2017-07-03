//
//  FeedViewControllerTests.swift
//  Instalick
//
//  Created by Patrick Montalto on 7/2/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import XCTest
import SwiftNetworking

@testable import Instalick

/// A mock client used to get feed items.
class FakeFeedClient: Gettable {
    
    var getWasCalled = false
    var getArrayWasCalled = false
    
    var getResult: Result<FeedItem>!
    var getArrayResult: Result<[FeedItem]>!
    
    func get(completion: @escaping (Result<FeedItem>) -> Void) {
        getWasCalled = true
        completion(getResult)
    }
    
    func getArray(completion: @escaping (Result<[FeedItem]>) -> Void) {
        getArrayWasCalled = true
        completion(getArrayResult)
    }
}

class FeedViewControllerTests: XCTestCase {
    
    // MARK: - Properties
    var client: FakeFeedClient!
    var viewController: FeedViewController!
    
    lazy var feedItemsArray: [FeedItem] = {
        (1...3).map() { self.generateFeedItem(id: $0) }
    }()

    // MARK: - Set up
    override func setUp() {
        super.setUp()
        
        client = FakeFeedClient()
        client.getResult = Result.success(generateFeedItem())
        client.getArrayResult = Result.success(feedItemsArray)
        
        viewController = FeedViewController()
        UIApplication.shared.keyWindow!.rootViewController = viewController
        
        // Load the View
        XCTAssertNotNil(viewController.view)
    }
    
    // MARK: - Helpers
    private func generateFeedItem(id: Int = 1) -> FeedItem {
        return FeedItem(albumId: id, id: id, title: "Test \(id)", urlString: "http://www.api.com/image/\(id)", thumbnailUrlString: "http://www.api.com/thumbnail/\(id)")
    }
    
    func testFetchFeedSuccess() {
        viewController.getFeed(fromClient: client)

        XCTAssertTrue(client.getArrayWasCalled)
        XCTAssertEqual(viewController.feedItems.count, feedItemsArray.count)
    }
    
    
}
