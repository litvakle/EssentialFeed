//
//  LocalFeedImageDataLoader.swift
//  EssentialFeed
//
//  Created by Lev Litvak on 22.08.2022.
//

import Foundation

public protocol FeedImageDataStore {
    typealias Result = Swift.Result<Data?, Error>
    func retrieve(dataFor url: URL, completion: @escaping (Result) -> Void)
}

public class LocalFeedImageDataLoader {
    let store: FeedImageDataStore
    
    public enum Error: Swift.Error {
        case failed
        case notFound
    }
    
    public init(store: FeedImageDataStore) {
        self.store = store
    }
    
    private class Task: FeedImageDataLoaderTask {
        private var completion: ((FeedImageDataLoader.Result) -> Void)?
        
        init(_ completion: @escaping (FeedImageDataLoader.Result) -> Void) {
            self.completion = completion
        }
        
        func complete(with result: FeedImageDataLoader.Result) {
            completion?(result)
        }
        
        func cancel() {
            preventFurtherCompletions()
        }
        
        private func preventFurtherCompletions() {
            completion = nil
        }
    }
    
    public func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
        let task = Task(completion)
        store.retrieve(dataFor: url) { result in
            switch result {
            case let .success(data):
                if let data = data {
                    task.complete(with: .success(data))
                } else {
                    task.complete(with: .failure(Error.notFound))
                }
            case .failure:
                task.complete(with: .failure(Error.failed))
            }
        }
        
        return task
    }
}
