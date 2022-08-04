//
//  LocalFeedLoader.swift
//  EssentialFeedMacOS
//
//  Created by Lev Litvak on 03.08.2022.
//

import Foundation

public final class LocalFeedLoader {
    private let store: FeedStore
    private let currentDate: () -> Date
    
    public typealias SaveResult = Error?
    public typealias LoadResult = LoadFeedResult
    
    let calendar = Calendar(identifier: .gregorian)
    
    public init(store: FeedStore, currentDate: @escaping () -> Date) {
        self.store = store
        self.currentDate = currentDate
    }
    
    public func save(_ feed: [FeedImage], completion: @escaping (SaveResult) -> Void) {
        store.deleteCachedFeed { [weak self] error in
            guard let self = self else { return }
            
            if let cacheDeletionError = error {
                completion(cacheDeletionError)
            } else {
                self.cache(feed, with: completion)
            }
        }
    }
    
    public func load(completion: @escaping (LoadResult) -> Void) {
        store.retrieve { [unowned self] result in
            switch result {
            case let .failure(error):
                store.deleteCachedFeed { _ in }
                completion(.failure(error))
            case let .found(feed, timeStamp) where self.validate(timeStamp):
                completion(.success(feed.toModels()))
            case .found, .empty:
                completion(.success([]))
            
            }
        }
    }
    
    private var maxCacheAgeInDays: Int { return 7 }
    
    private func validate(_ timeStamp: Date) -> Bool {
        guard let maxCachedAge = calendar.date(byAdding: .day, value: maxCacheAgeInDays, to:  timeStamp) else { return false }
        
        return currentDate() < maxCachedAge
    }
    
    private func cache(_ feed: [FeedImage], with completion: @escaping (SaveResult) -> Void) {
        store.insert(feed.toLocal(), timestamp: currentDate()) { [weak self] cacheInsertionError in
            guard self != nil else { return }
            
            completion(cacheInsertionError)
        }
    }
}

private extension Array where Element == FeedImage {
    func toLocal() -> [LocalFeedImage] {
        return self.map {
            LocalFeedImage(id: $0.id,
                          description: $0.description,
                          location: $0.location,
                          url: $0.url)
        }
    }
}

private extension Array where Element == LocalFeedImage {
    func toModels() -> [FeedImage] {
        return self.map {
            FeedImage(id: $0.id,
                          description: $0.description,
                          location: $0.location,
                          url: $0.url)
        }
    }
}
