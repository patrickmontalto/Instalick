//
//  FeedItem.swift
//  Instalick
//
//  Created by Patrick Montalto on 6/29/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import Foundation
import JSON

struct FeedItem {
    
    /// The keys of each feed item JSON object.
    enum Key {
        static let albumId = "albumId"
        static let id = "id"
        static let title = "title"
        static let urlString = "url"
        static let thumbnailUrlString = "thumbnailUrl"
    }
    
    // MARK: - Properties
    
    /// The album the feed item belongs to.
    var albumId: Int
    
    /// The unique identifier of the feed item.
    var id: Int
    
    /// The feed item's title.
    var title: String
    
    /// A string containing the URL to the photo of the feed item.
    var urlString: String
    
    /// A string containing the URL to the thumbnail photo of the feed item.
    var thumbnailUrlString: String
    
    /// A URL to the photo of the feed item.
    var photoURL: URL? {
        return URL(string: urlString)
    }
    
    /// A URL to the thumbnail photo of the feed item.
    var thumbnailURL: URL? {
        return URL(string: thumbnailUrlString)
    }
}

extension FeedItem: JSONDeserializable {
    init(jsonRepresentation json: JSONDictionary) throws {
        albumId = try decode(json, key: Key.albumId)
        id = try decode(json, key: Key.id)
        title = try decode(json, key: Key.title)
        urlString = try decode(json, key: Key.urlString)
        thumbnailUrlString = try decode(json, key: Key.thumbnailUrlString)
    }
}
