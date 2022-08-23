//
//  LocalFeedImageDataLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Lev Litvak on 22.08.2022.
//

import Foundation
import EssentialFeed
import XCTest

class LocalFeedImageDataLoaderTests: XCTestCase {
    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()
        
        XCTAssertTrue(store.receivedMessages.isEmpty)
    }
    
    func test_loadImageData_requestsStoredDataFromURL() {
        let (sut, store) = makeSUT()
        let url = anyURL()
        
        sut.loadImageData(from: url) { _ in }
        
        XCTAssertEqual(store.receivedMessages, [.retrieve(dataFor: url)])
    }
    
    func test_loadImageData_failsOnStoreError() {
        let (sut, store) = makeSUT()
        let expectedError = LocalFeedImageDataLoader.Error.failed
        
        expect(sut, toCompleteWith: .failure(expectedError), when: {
            store.complete(withError: anyNSError(), at: 0)
        })
    }
    
    // MARK: - Helpers
    
    private func makeSUT(currentDate: @escaping () -> Date = Date.init, file: StaticString = #file, line: UInt = #line) -> (sut: LocalFeedImageDataLoader, store: FeedStoreSpy) {
        let store = FeedStoreSpy()
        let sut = LocalFeedImageDataLoader(store: store)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
    
    private func expect(_ sut: LocalFeedImageDataLoader, toCompleteWith expectedResult: FeedImageDataLoader.Result, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for load image data completion")
        let url = anyURL()
        
        sut.loadImageData(from: url) { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedImages), .success(expectedImages)):
                XCTAssertEqual(receivedImages, expectedImages, file: file, line: line)
            case let (.failure(receivedError as LocalFeedImageDataLoader.Error), .failure(expectedError as LocalFeedImageDataLoader.Error)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)
            default:
                XCTFail("Expected result \(expectedResult), got \(receivedResult) instead", file: file, line: line)
            }
            
            exp.fulfill()
        }
        
        action()
        
        wait(for: [exp], timeout: 1.0)
    }
    
    private class FeedStoreSpy: FeedImageDataStore {
        enum Message: Equatable {
            case retrieve(dataFor: URL)
        }
        
        var receivedMessages = [Message]()
        var completions = [(FeedImageDataStore.Result) -> Void]()
        
        func retrieve(dataFor url: URL, completion: @escaping (FeedImageDataStore.Result) -> Void) {
            receivedMessages.append(.retrieve(dataFor: url))
            completions.append(completion)
        }
        
        func complete(withError error: Error, at index: Int) {
            completions[index](.failure(error))
        }
    }
}
