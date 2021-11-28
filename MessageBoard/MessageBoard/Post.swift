//
//  Post.swift
//  MessageBoard
//
//  Created by angel zambrano on 11/28/21.
//

import Foundation


// MARK: TODO - Fill this file in with models to properly decode the JSON responses from the server
class Post {
    let id: Int
    let title: String
    let body: String
    let hashedPoster: String
    let timestamp: String
    
    init(id: Int, title: String, body: String, hashedPoster: String, timestamp: String) {
        self.id = id
        self.title = title
        self.body = body
        self.hashedPoster = hashedPoster
        self.timestamp = timestamp
    }
}
