//
//  RemoteFeedImageDataLoader.swift
//  EssentialFeed
//
//  Created by Lev Litvak on 22.08.2022.
//

import Foundation

public class RemoteFeedImageDataLoader {
    let client: HTTPClient
    
    public enum Error: Swift.Error {
        case invalidData
    }
    
    public init(client: HTTPClient) {
        self.client = client
    }
    
    public func loadImageDataFromURL(url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) {
        client.get(from: url) { result in
            switch result {
            case .success:
                completion(.failure(Error.invalidData))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
