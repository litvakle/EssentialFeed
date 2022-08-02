//
//  CacheFeedUseCase.swift
//  EssentialFeedMacOSTests
//
//  Created by Lev Litvak on 02.08.2022.
//

import XCTest
import EssentialFeedMacOS

class LocalFeedLoader {
    private let store: FeedStore
    
    init(store: FeedStore) {
        self.store = store
    }
    
    func save(_ items: [FeedItem]) {
        store.deleteCachedFeed()
    }
}

class FeedStore {
    var deleteCachedFeedCallCount = 0
    
    func deleteCachedFeed() {
        deleteCachedFeedCallCount += 1
    }
}

class CacheFeedUseCase: XCTestCase {
    func test_init_doesNotDeleteCacheUponCreation() {
        let (_, store) = makeSUT()

        XCTAssertEqual(store.deleteCachedFeedCallCount, 0)
    }
    
    func test_save_requestCacheDeletion() {
        let (sut, store) = makeSUT()
        
        let items = [uniqueItem(), uniqueItem()]
        
        sut.save(items)
        
        XCTAssertEqual(store.deleteCachedFeedCallCount, 1)
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> (sut: LocalFeedLoader, store: FeedStore) {
        let store = FeedStore()
        let sut = LocalFeedLoader(store: store)
        
        return (sut, store)
    }
    
    private func uniqueItem() -> FeedItem {
        return FeedItem(id: UUID(),
                        description: nil,
                        location: nil,
                        imageURL: anyURL())
    }
    
    private func anyURL() -> URL {
        return URL(string: "http://any-url.com")!
    }
}
