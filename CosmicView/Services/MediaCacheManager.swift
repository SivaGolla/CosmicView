//
//  MediaCacheManager.swift
//  CosmicView
//
//  Created by Venkata Sivannarayana Golla on 03/09/24.
//

import UIKit

class MediaCacheManager {
    
    // Singleton instance
    static let shared = MediaCacheManager()
    
    /// A shared image cache used throughout the app to store and retrieve images.
    /// This cache is key-value based, where the key is a string (typically the image URL) and the value is the cached UIImage.
    private var imageCache = NSCache<NSString, UIImage>()
    
    private init() {
        // Optionally set cache limits
        imageCache.countLimit = 100 // Maximum number of images in cache
        imageCache.totalCostLimit = 100 * 1024 * 1024 // Maximum memory limit in bytes = 100MB
    }
    
    // Save an image to the cache
    func saveImage(_ image: UIImage, forKey key: String) {
        let cacheKey = NSString(string: key)
        imageCache.setObject(image, forKey: cacheKey)
    }
    
    // Retrieve an image from the cache
    func loadImage(forKey key: String) -> UIImage? {
        let cacheKey = NSString(string: key)
        return imageCache.object(forKey: cacheKey)
    }
}
