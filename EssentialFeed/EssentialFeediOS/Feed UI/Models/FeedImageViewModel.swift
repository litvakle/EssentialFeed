//
//  FeedImageViewModel.swift
//  EssentialFeediOS
//
//  Created by Lev Litvak on 15.08.2022.
//

import Foundation
import EssentialFeed
import UIKit

final class FeedImageViewModel {
    typealias Observer<T> = ((T) -> Void)
    
    private let model: FeedImage
    private let loader: FeedImageDataLoader
    private var task: FeedImageDataLoaderTask?
    
    init(model: FeedImage, loader: FeedImageDataLoader) {
        self.model = model
        self.loader = loader
    }
    
    var onImageLoadingChangeState: Observer<Bool>?
    var onImageLoad: Observer<UIImage>?
    var onShouldRetryImageLoadStateChange: Observer<Bool>?
    
    var description: String? {
        return model.description
    }
    
    var location: String? {
        return model.location
    }
    
    var hasLocation: Bool {
        return model.location != nil
    }
    
    func loadImageData() {
        onImageLoadingChangeState?(true)
        onShouldRetryImageLoadStateChange?(false)
        
        task = loader.loadImageData(from: model.url) { [weak self] result in
            if let image = (try? result.get()).flatMap(UIImage.init) {
                self?.onImageLoad?(image)
            } else {
                self?.onShouldRetryImageLoadStateChange?(true)
            }
            
            self?.onImageLoadingChangeState?(false)
        }
    }
    
    func cancelImageDataLoad() {
        task?.cancel()
        task = nil
    }
}
