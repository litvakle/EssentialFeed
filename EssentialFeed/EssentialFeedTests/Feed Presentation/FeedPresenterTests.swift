//
//  FeedPresenterTests.swift
//  EssentialFeedTests
//
//  Created by Lev Litvak on 21.08.2022.
//

import XCTest

class FeedPresenter {
    init(view: Any) {
        
    }
}

class FeedPresenterTests: XCTestCase {
    func test_init_doesNotSentMessagesToView() {
        let view = ViewSpy()
        
        _ = FeedPresenter(view: view)
        
        XCTAssertTrue(view.messages.isEmpty, "Exptected no view messages")
    }
    
    // MARK: - Helpers
    
    private class ViewSpy {
        let messages = [Any]()
    }
}
