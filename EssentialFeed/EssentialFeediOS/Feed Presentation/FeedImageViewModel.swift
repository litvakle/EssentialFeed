//
//  FeedImageViewModel.swift
//  EssentialFeediOS
//
//  Created by Lev Litvak on 15.08.2022.
//

import Foundation
import EssentialFeed

final class FeedImageViewModel<Image> {
    typealias Observer<T> = ((T) -> Void)
    
    private var task: FeedImageDataLoaderTask?
    private let model: FeedImage
    private let loader: FeedImageDataLoader
    private let imageTransformer: (Data) -> Image?
    
    init(model: FeedImage, loader: FeedImageDataLoader, imageTransformer: @escaping (Data) -> Image?) {
        self.model = model
        self.loader = loader
        self.imageTransformer = imageTransformer
    }
    
    var onImageLoadingChangeState: Observer<Bool>?
    var onImageLoad: Observer<Image>?
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
            self?.handle(result)
        }
    }
    
    private func handle(_ result: FeedImageDataLoader.Result) {
        if let image = (try? result.get()).flatMap(imageTransformer) {
            onImageLoad?(image)
        } else {
            onShouldRetryImageLoadStateChange?(true)
        }
        
        onImageLoadingChangeState?(false)
    }
    
    func cancelImageDataLoad() {
        task?.cancel()
        task = nil
    }
}
