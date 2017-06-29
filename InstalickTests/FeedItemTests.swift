//
//  FeedItemTests.swift
//  Instalick
//
//  Created by Patrick Montalto on 6/29/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import XCTest
@testable import Instalick

class FeedItemTests: XCTestCase {
    
    // MARK: - Properties
    let testTitle = "My Title"
    let testUrlString = "http://placehold.it/600/92c952"
    let testThumbnailUrlString = "http://placehold.it/150/92c952"
    
    lazy var testJSON: [String: Any] = {
        return ["albumId": 1,
                "id": 1,
                "title": self.testTitle,
                "url": self.testUrlString,
                "thumbnailUrl": self.testThumbnailUrlString]
    }()
    
    // MARK: - Setup
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    // MARK: - Tests
    func testCanInitFeedItemWithJSON() {
        let feedItem = try! FeedItem(jsonRepresentation: testJSON)
        
        XCTAssertEqual(feedItem.albumId, 1)
        XCTAssertEqual(feedItem.id, 1)
        XCTAssertEqual(feedItem.title, testTitle)
        XCTAssertEqual(feedItem.urlString, testUrlString)
        XCTAssertEqual(feedItem.thumbnailUrlString, testThumbnailUrlString)
    }
    
    func testFeedItemHasPhotoURLandThumbnailURL() {
        let feedItem = try! FeedItem(jsonRepresentation: testJSON)
        
        XCTAssertEqual(feedItem.photoURL!, URL(string: testUrlString)!)
        XCTAssertEqual(feedItem.thumbnailURL!, URL(string: testThumbnailUrlString)!)
    }
}
