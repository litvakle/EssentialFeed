//
//  FeedLoader.swift
//  EssentialFeedMacOS
//
//  Created by Lev Litvak on 27.07.2022.
//

import Foundation


public protocol FeedLoader {
    typealias Result = Swift.Result<[FeedImage], Error>
    
    func load(completion: @escaping(Result) -> Void)
}
