//
//  SharedTestHelpers.swift
//  EssentialFeedMacOSTests
//
//  Created by Lev Litvak on 04.08.2022.
//

import Foundation

func anyURL() -> URL {
    return URL(string: "http://any-url.com")!
}

func anyNSError() -> NSError {
    return NSError(domain: "any error", code: 1)
}

func anyData() -> Data {
    return Data("any data".utf8)
}
