//
//  FeedLoader.swift
//  EssentialFeedMacOS
//
//  Created by Lev Litvak on 27.07.2022.
//

import Foundation

enum LoadFeedResult {
    case success([FeedItem])
    case error(Error)
}

protocol FeedLoader {
    func load(completion: @escaping(LoadFeedResult) -> Void)
}
