//
//  LocalFeedImageDataLoader.swift
//  EssentialFeed
//
//  Created by Lev Litvak on 22.08.2022.
//

import Foundation

public protocol FeedImageDataStore {
    typealias Result = Swift.Result<Data, Error>
    func retrieve(dataFor url: URL, completion: @escaping (Result) -> Void)
}

public class LocalFeedImageDataLoader {
    let store: FeedImageDataStore
    
    public enum Error: Swift.Error {
        case failed
    }
    
    public init(store: FeedImageDataStore) {
        self.store = store
    }
    
    public func loadImageData(from url: URL, completion: @escaping (FeedImageDataStore.Result) -> Void) {
        store.retrieve(dataFor: url) { result in
            completion(.failure(Error.failed))
        }
    }
}
