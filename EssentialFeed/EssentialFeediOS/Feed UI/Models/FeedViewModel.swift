//
//  FeedViewModel.swift
//  EssentialFeediOS
//
//  Created by Lev Litvak on 15.08.2022.
//

import Foundation
import EssentialFeed

final class FeedViewModel {
    typealias Observer<T> = (T) -> Void
    private let feedLoader: FeedLoader
    
    init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }
    
    var onLoadingStateChange: Observer<Bool>?
    var onFeedLoad: Observer<[FeedImage]>?
    
    func loadFeed() {
        onLoadingStateChange?(true)
        feedLoader.load { [weak self] result in
            if case let .success(feed) = result {
                self?.onFeedLoad?(feed)
            }
             
            self?.onLoadingStateChange?(false)
        }
    }
}
