//
//  FeedCacheTestHelpers.swift
//  EssentialFeedMacOSTests
//
//  Created by Lev Litvak on 04.08.2022.
//

import Foundation
import EssentialFeedMacOS

func uniqueImageFeed() -> (model: [FeedImage], local: [LocalFeedImage]) {
    let models = [uniqueImage(), uniqueImage()]
    let local = models.map {
        LocalFeedImage(id: $0.id,
                      description: $0.description,
                      location: $0.location,
                      url: $0.url)
    }
    
    return (models, local)
}

func uniqueImage() -> FeedImage {
    return FeedImage(id: UUID(),
                    description: nil,
                    location: nil,
                    url: anyURL())
}

extension Date {
    func minusMaxFeedCacheAge() -> Date {
        return self.adding(days: -maxAgeCacheFeedInDays)
    }
    
    private var maxAgeCacheFeedInDays: Int {
        return 7
    }
    
    func adding(days: Int) -> Date {
        return Calendar(identifier: .gregorian).date(byAdding: .day, value: days, to: self)!
    }
    
    func adding(seconds: TimeInterval) -> Date {
        return self + seconds
    }
}
