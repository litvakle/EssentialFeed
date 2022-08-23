//
//  FeedImageDataStore.swift
//  EssentialFeed
//
//  Created by Lev Litvak on 23.08.2022.
//

import Foundation

public protocol FeedImageDataStore {
    typealias RetrivalResult = Swift.Result<Data?, Error>
    typealias InsertionResult = Swift.Result<Void, Error>
    
    func retrieve(dataFor url: URL, completion: @escaping (RetrivalResult) -> Void)
    func insert(_ data: Data, for url: URL, completion: @escaping (InsertionResult) -> Void)
}
