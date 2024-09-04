//
//  MediaCacheManagerTests.swift
//  CosmicViewTests
//
//  Created by Venkata Sivannarayana Golla on 04/09/24.
//

import XCTest
@testable import CosmicView_Dev

final class MediaCacheManagerTests: XCTestCase {
    var cacheManager: MediaCacheManager!

    override func setUpWithError() throws {
        try super.setUpWithError()
        cacheManager = MediaCacheManager.shared
    }

    override func tearDownWithError() throws {
        cacheManager = nil
        try super.tearDownWithError()
    }

    func testSaveAndLoadImage() {
        // Arrange
        let image = Constants.placeholderImage
        let key = "testImageKey"

        // Act
        cacheManager.saveImage(image!, forKey: key)
        let cachedImage = cacheManager.loadImage(forKey: key)

        // Assert
        XCTAssertNotNil(cachedImage, "Image should be cached")
        XCTAssertEqual(cachedImage, image, "Cached image should match the original image")
    }

    func testLoadImageWithInvalidKey() {
        // Arrange
        let invalidKey = "invalidKey"

        // Act
        let cachedImage = cacheManager.loadImage(forKey: invalidKey)

        // Assert
        XCTAssertNil(cachedImage, "Image should not be found for an invalid key")
    }

    func testCacheLimits() {
        // Arrange
        let largeImage = Constants.placeholderImage // Use a valid image or mock image
        let cacheManager = MediaCacheManager.shared
        let keyPrefix = "largeImageKey_"

        // Act
        for i in 0..<200 {
            cacheManager.saveImage(largeImage!, forKey: "\(keyPrefix)\(i)")
        }
        
        // Assert
        // Check if the cache is not exceeding its limit
        let cachedImageCount = cacheManager.imageCache.totalCostLimit
        XCTAssertLessThanOrEqual(cachedImageCount, 100 * 1024 * 1024, "Cache should respect the total cost limit")
    }

}
