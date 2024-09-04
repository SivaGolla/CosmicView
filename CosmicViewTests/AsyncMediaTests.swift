//
//  AsyncMediaTests.swift
//  CosmicViewTests
//
//  Created by Venkata Sivannarayana Golla on 03/09/24.
//

import XCTest
@testable import CosmicView_Dev

final class AsyncMediaTests: XCTestCase {
    
    var networkManager: NetworkManager!
    var session: MockURLSession!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        session = MockURLSession()
        session.mDelegate = self
        networkManager = NetworkManager(session: session)
    }
    
    override func tearDownWithError() throws {
        session.mDelegate = nil
        session = nil
        networkManager = nil
        try super.tearDownWithError()
    }
    
    func testLoadImageWithEmptyUrlReturnsPlaceholder() {
        // Arrange
        let placeholder = UIImage(named: "placeholder")
        let expectation = XCTestExpectation(description: "Completion handler called")
        
        // Act
        AsyncMedia.loadImage(urlPath: "", session: session, placeholder: placeholder) { image in
            // Assert
            XCTAssertEqual(image, placeholder)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testLoadImageWithCachedImageReturnsCachedImage() {
        // Arrange
        let urlPath = "https://example.com/cached/image.jpg"
        let cachedImage = UIImage(named: "PlaceholderApod")
        MediaCacheManager.shared.saveImage(cachedImage!, forKey: urlPath)
        let expectation = XCTestExpectation(description: "Completion handler called")
        
        // Act
        AsyncMedia.loadImage(urlPath: urlPath, session: session, placeholder: nil) { image in
            // Assert
            XCTAssertEqual(image, cachedImage)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testLoadImageWithInvalidUrlReturnsPlaceholder() {
        // Arrange
        let invalidUrlPath = "invalid-url"
        let placeholder = Constants.placeholderImage
        let expectation = XCTestExpectation(description: "Completion handler called")
        
        // Act
        AsyncMedia.loadImage(urlPath: invalidUrlPath, session: session, placeholder: placeholder) { image in
            // Assert
            XCTAssertEqual(image, placeholder)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testLoadAsyncImageWithEmptyUrlReturnsPlaceholder() async throws {
        // Arrange
        let placeholder = Constants.placeholderImage
        
        // Act
        let image = try await AsyncMedia.loadImage(urlPath: "", session: session, placeholder: placeholder)
        
        // Assert
        XCTAssertEqual(image, placeholder)
    }
    
    func testLoadAsyncImageWithCachedImageReturnsCachedImage() async throws {
        // Arrange
        let urlPath = "https://example.com/cached/image.jpg"
        let cachedImage = UIImage(named: "CachedImage")
        MediaCacheManager.shared.saveImage(cachedImage!, forKey: urlPath)
        
        // Act
        let image = try await AsyncMedia.loadImage(urlPath: urlPath, session: session, placeholder: nil)
        
        // Assert
        XCTAssertEqual(image, cachedImage)
    }
    
    func testLoadAsyncImageWithInvalidUrlReturnsPlaceholder() async throws {
        // Arrange
        let invalidUrlPath = "invalid-url"
        let placeholder = Constants.placeholderImage
        
        // Act
        let image = try await AsyncMedia.loadImage(urlPath: invalidUrlPath, session: session, placeholder: placeholder)
        
        // Assert
        XCTAssertEqual(image, placeholder)
    }
}

extension AsyncMediaTests: MockURLSessionDelegate {
    func resourceName(for path: String, httpMethod: String) -> String {
        if path.contains("cached") {
            return "CachedImage"
        }
        
        if path.contains("downloaded") {
            return "CachedImage"
        }
        
        return "NasaApod"
    }
}
