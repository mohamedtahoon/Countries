//
//  ImageLoader.swift
//  cmeCountries
//
//  Created by mohamed tahoon on 17/01/2025.
//

import Foundation

import Combine
import UIKit

class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    private var url: URL?
    private var cancellable: AnyCancellable?
    
    // Image cache
    private static let imageCache = NSCache<NSString, UIImage>()
    
    init(url: URL?) {
        self.url = url
        loadImage()
    }
    
    deinit {
        cancellable?.cancel()
    }
    
    private func loadImage() {
        guard let url = url else { return }
        
        // Check cache first
        if let cachedImage = ImageLoader.imageCache.object(forKey: url.absoluteString as NSString) {
            self.image = cachedImage
            return
        }
        
        // Load image from network
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] loadedImage in
                if let loadedImage = loadedImage {
                    // Cache the image
                    ImageLoader.imageCache.setObject(loadedImage, forKey: url.absoluteString as NSString)
                }
                self?.image = loadedImage
            }
    }
}
