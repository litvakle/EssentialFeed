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
    var retrivalCompletions = [(FeedImageDataStore.RetrivalResult) -> Void]()
    var insertionCompletions = [(FeedImageDataStore.InsertionResult) -> Void]()
    
    func retrieve(dataFor url: URL, completion: @escaping (FeedImageDataStore.RetrivalResult) -> Void) {
        receivedMessages.append(.retrieve(dataFor: url))
        retrivalCompletions.append(completion)
    }
    
    func completeRetrival(withError error: Error, at index: Int = 0) {
        retrivalCompletions[index](.failure(error))
    }
    
    func completeRetrival(withData data: Data?, at index: Int = 0) {
        retrivalCompletions[index](.success(data))
    }
    
    func insert(_ data: Data, for url: URL, completion: @escaping (InsertionResult) -> Void) {
        receivedMessages.append(.insert(data: data, for: url))
        insertionCompletions.append(completion)
    }
    
    func completeInsertion(withError error: Error, at index: Int = 0) {
        insertionCompletions[index](.failure(error))
    }
    
    func completeInsertionSuccessfully(at index: Int = 0) {
        insertionCompletions[index](.success(()))
    }
}
