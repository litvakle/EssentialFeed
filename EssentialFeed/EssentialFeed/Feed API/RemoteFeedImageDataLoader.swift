//
//  RemoteFeedImageDataLoader.swift
//  EssentialFeed
//
//  Created by Lev Litvak on 22.08.2022.
//

import Foundation

public class RemoteFeedImageDataLoader {
    let client: HTTPClient
    
    public init(client: HTTPClient) {
        self.client = client
    }
    
    public func loadImageDataFromURL(url: URL, completion: @escaping (Any) -> Void) {
        client.get(from: url) { _ in }
    }
}
