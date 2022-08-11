//
//  FeedCachePolicy.swift
//  EssentialFeedMacOS
//
//  Created by Lev Litvak on 05.08.2022.
//

import Foundation

internal final class FeedCachePolicy {
    static private let calendar = Calendar(identifier: .gregorian)
    
    static private var maxCacheAgeInDays: Int {
        return 7
    }

    private init() {}
    
    static func validate(_ timeStamp: Date, against date: Date) -> Bool {
        guard let maxCachedAge = calendar.date(byAdding: .day, value: maxCacheAgeInDays, to:  timeStamp) else { return false }
        
        return date < maxCachedAge
    }
}
