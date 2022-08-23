//
//  FeedImageDataStore.swift
//  EssentialFeed
//
//  Created by Lev Litvak on 23.08.2022.
//

import Foundation

public protocol FeedImageDataStore {
    typealias Result = Swift.Result<Data?, Error>
    func retrieve(dataFor url: URL, completion: @escaping (Result) -> Void)
}
