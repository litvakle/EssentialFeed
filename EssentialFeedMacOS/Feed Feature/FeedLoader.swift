//
//  FeedLoader.swift
//  EssentialFeedMacOS
//
//  Created by Lev Litvak on 27.07.2022.
//

import Foundation

public enum LoadFeedResult<Error: Swift.Error> {
    case success([FeedItem])
    case failure(Error)
}

protocol FeedLoader {
    associatedtype Error: Swift.Error
    func load(completion: @escaping(LoadFeedResult<Error>) -> Void)
}
