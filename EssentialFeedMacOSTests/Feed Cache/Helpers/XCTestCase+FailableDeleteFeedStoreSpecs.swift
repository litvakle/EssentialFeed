//
//  XCTestCase+FailableDeleteFeedStoreSpecs.swift
//  EssentialFeedMacOSTests
//
//  Created by Lev Litvak on 08.08.2022.
//

import Foundation
import XCTest
import EssentialFeedMacOS

extension FailableDeleteFeedStoreSpecs where Self: XCTestCase {
    func assertThatDeleteDeliversErrorOnDeletionError(on sut: FeedStore, file: StaticString = #file, line: UInt = #line) {
        let deletionError = deleteCache(from: sut)
        XCTAssertNotNil(deletionError, "Expected cache deletion to fail", file: file, line: line)
    }
    
    func assertThatDeleteHasNoSideEffectsOnDeletionError(on sut: FeedStore, file: StaticString = #file, line: UInt = #line) {
        deleteCache(from: sut)
        expect(sut, toRetrieve: .empty, file: file, line: line)
    }
}
