//
//  FeedImageDataStoreSpy.swift
//  EssentialFeedTests
//
//  Created by Lev Litvak on 23.08.2022.
//

import Foundation
import EssentialFeed

class FeedImageDataStoreSpy: FeedImageDataStore {
    enum Message: Equatable {
        case retrieve(dataFor: URL)
        case insert(data: Data, for: URL)
    }
    
    var receivedMessages = [Message]()
    var completions = [(FeedImageDataStore.RetrivalResult) -> Void]()
    
    func retrieve(dataFor url: URL, completion: @escaping (FeedImageDataStore.RetrivalResult) -> Void) {
        receivedMessages.append(.retrieve(dataFor: url))
        completions.append(completion)
    }
    
    func complete(withError error: Error, at index: Int = 0) {
        completions[index](.failure(error))
    }
    
    func complete(withData data: Data?, at index: Int = 0) {
        completions[index](.success(data))
    }
    
    func insert(_ data: Data, for url: URL, completion: @escaping (InsertionResult) -> Void) {
        receivedMessages.append(.insert(data: data, for: url))
    }
}
