//
//  XCTestCase+FailableInsertFeedStoreSpecs.swift
//  EssentialFeedMacOSTests
//
//  Created by Lev Litvak on 08.08.2022.
//

import Foundation
import XCTest
import EssentialFeedMacOS

extension FailableInsertFeedStoreSpecs where Self: XCTestCase {
    func assertThatInsertDeliversErrorOnInsertionError(on sut: FeedStore, file: StaticString = #file, line: UInt = #line) {
        let feed = uniqueImageFeed().local
        let timestamp = Date()
        
        let insetionError = insert((feed, timestamp), to: sut)
        
        XCTAssertNotNil(insetionError, "Expected cache insertion to fail with an error", file: file, line: line)
    }
    
    func assertThatInsertHasNoSideEffectsOnInsertionError(on sut: FeedStore, file: StaticString = #file, line: UInt = #line) {
        insert((uniqueImageFeed().local, Date()), to: sut)
        expect(sut, toRetrieve: .success(.none), file: file, line: line)
    }
}
