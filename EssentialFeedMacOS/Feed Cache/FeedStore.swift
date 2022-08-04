//
//  FeedStore.swift
//  EssentialFeedMacOS
//
//  Created by Lev Litvak on 03.08.2022.
//

import Foundation

public enum RetrievedCacheFeedResult {
    case empty
    case found(feed: [LocalFeedImage], timeStamp: Date)
    case failure(Error)
}

public protocol FeedStore {
    typealias DeletionCompletion = (Error?) -> Void
    typealias InsertionCompletion = (Error?) -> Void
    typealias RetrievalCompletion = (RetrievedCacheFeedResult) -> Void
    
    func deleteCachedFeed(completion: @escaping DeletionCompletion)
    func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion)
    func retrieve(completion: @escaping RetrievalCompletion)
}
