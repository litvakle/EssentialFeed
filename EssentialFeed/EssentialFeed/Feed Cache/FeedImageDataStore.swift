//
//  FeedImageDataStore.swift
//  EssentialFeed
//
//  Created by Lev Litvak on 23.08.2022.
//

import Foundation

public protocol FeedImageDataStore {
    typealias Result = Swift.Result<Data?, Error>
    typealias SaveResult = Swift.Result<Void, Error>
    
    func retrieve(dataFor url: URL, completion: @escaping (Result) -> Void)
    func save(_ data: Data, for url: URL, completion: @escaping (SaveResult) -> Void)
}
