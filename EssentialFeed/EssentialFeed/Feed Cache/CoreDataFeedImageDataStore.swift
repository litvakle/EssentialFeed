//
//  CoreDataFeedImageDataStore.swift
//  EssentialFeed
//
//  Created by Lev Litvak on 24.08.2022.
//

import Foundation

extension CoreDataFeedStore: FeedImageDataStore {
    
    public func retrieve(dataFor url: URL, completion: @escaping (RetrivalResult) -> Void) {
        completion(.success(.none))
    }
    
    public func insert(_ data: Data, for url: URL, completion: @escaping (InsertionResult) -> Void) {
        
    }
}
