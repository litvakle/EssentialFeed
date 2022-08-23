//
//  LocalFeedImageDataFromCacheUseCaseTests.swift
//  EssentialFeedTests
//
//  Created by Lev Litvak on 22.08.2022.
//

import Foundation
import EssentialFeed
import XCTest

class LocalFeedImageDataFromCacheUseCaseTests: XCTestCase {
    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()
        
        XCTAssertTrue(store.receivedMessages.isEmpty)
    }
    
    func test_loadImageData_requestsStoredDataFromURL() {
        let (sut, store) = makeSUT()
        let url = anyURL()
        
        _ = sut.loadImageData(from: url) { _ in }
        
        XCTAssertEqual(store.receivedMessages, [.retrieve(dataFor: url)])
    }
    
    func test_loadImageData_failsOnStoreError() {
        let (sut, store) = makeSUT()
        let expectedError = LocalFeedImageDataLoader.Error.failed
        
        expect(sut, toCompleteWith: .failure(expectedError), when: {
            store.complete(withError: anyNSError(), at: 0)
        })
    }
    
    func test_loadImageData_deliversNotFoundErrorWhenStoreCantFindImageDataOnURL() {
        let (sut, store) = makeSUT()
        
        expect(sut, toCompleteWith: .failure(LocalFeedImageDataLoader.Error.notFound), when: {
            store.complete(withData: nil, at: 0)
        })
    }
    
    func test_loadImageData_deliversStoredDataWhenStoreCanFindImageDataOnURL() {
        let (sut, store) = makeSUT()
        let expectedData = Data("stored data".utf8)
        
        expect(sut, toCompleteWith: .success(expectedData), when: {
            store.complete(withData: expectedData, at: 0)
        })
    }
    
    func test_loadImageData_doesNotDeliverResultAfterCancellingTask() {
        let (sut, store) = makeSUT()
        var capturedResults = [FeedImageDataLoader.Result]()
        
        let task = sut.loadImageData(from: anyURL()) { result in
            capturedResults.append(result)
        }

        task.cancel()
        store.complete(withError: anyNSError(), at: 0)
        store.complete(withData: nil, at: 0)
        store.complete(withData: anyData(), at: 0)
        
        XCTAssertTrue(capturedResults.isEmpty, "Expected no delivered results after cancelling task")
    }
    
    func test_loadImageData_doesNotDeliverResultAfterSUTInstanceHasBeenDeallocated() {
        let store = FeedImageDataStoreSpy()
        var sut: LocalFeedImageDataLoader? = LocalFeedImageDataLoader(store: store)
        
        var received = [FeedImageDataLoader.Result]()
        _ = sut?.loadImageData(from: anyURL()) { received.append($0) }
        
        sut = nil
        store.complete(withData: anyData())
        
        XCTAssertTrue(received.isEmpty, "Expected no received results after instance has been deallocated")
    }
    
    // MARK: - Helpers
    
    private func makeSUT(currentDate: @escaping () -> Date = Date.init, file: StaticString = #file, line: UInt = #line) -> (sut: LocalFeedImageDataLoader, store: FeedImageDataStoreSpy) {
        let store = FeedImageDataStoreSpy()
        let sut = LocalFeedImageDataLoader(store: store)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
    
    private func expect(_ sut: LocalFeedImageDataLoader, toCompleteWith expectedResult: FeedImageDataLoader.Result, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for load image data completion")
        let url = anyURL()
        
        _ = sut.loadImageData(from: url) { receivedResult in
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
}
