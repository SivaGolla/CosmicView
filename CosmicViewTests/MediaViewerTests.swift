//
//  MediaViewerTests.swift
//  CosmicViewTests
//
//  Created by Venkata Sivannarayana Golla on 04/09/24.
//

import XCTest
import WebKit
import YouTubeiOSPlayerHelper
@testable import CosmicView_Dev

final class MediaViewerTests: XCTestCase {

    var mediaViewer: MediaViewer!

    override func setUpWithError() throws {
        try super.setUpWithError()
        mediaViewer = MediaViewer(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    }

    override func tearDownWithError() throws {
        mediaViewer = nil
        try super.tearDownWithError()
    }

    func testMediaItemWithImage() {
        // Given
        let mediaItem = CosmicSnapshot(title: "Test Image",
                                       dateText: "2024-08-14",
                                       explanation: "Test Description",
                                       mediaType: .image,
                                       url: "",
                                       hdUrl: "https://example.com/image.jpg",
                                       thumbnailUrl: "")
        
        // When
        mediaViewer.mediaItem = mediaItem
        
        // Then
        XCTAssertEqual(mediaViewer.imageTitle.text, "Test Image")
        XCTAssertEqual(mediaViewer.descLabel.text, "Test Description")
        XCTAssertFalse(mediaViewer.imageView.isHidden)
        XCTAssertTrue(mediaViewer.webPlayerView.isHidden)
        XCTAssertTrue(mediaViewer.youTublePlayerView.isHidden)
    }

    func testMediaItemWithYouTubeVideo() {
        // Given
        let mediaItem = CosmicSnapshot(title: "Test YouTube",
                                       dateText: "2024-08-18",
                                       explanation: "Test Description",
                                       mediaType: .video,
                                       url: "https://www.youtube.com/embed/PBL1RBj-P1g?rel=0",
                                       hdUrl: "https://www.youtube.com/embed/PBL1RBj-P1g?rel=0",
                                       thumbnailUrl: "")
                
        // When
        mediaViewer.mediaItem = mediaItem
        
        // Then
        XCTAssertFalse(mediaViewer.youTublePlayerView.isHidden)
        XCTAssertTrue(mediaViewer.imageView.isHidden)
        XCTAssertTrue(mediaViewer.webPlayerView.isHidden)
    }
    
    func testMediaItemWithWebVideo() {
        // Given
        let mediaItem = CosmicSnapshot(title: "Test Web Video",
                                       dateText: "2024-08-18",
                                       explanation: "Test Description",
                                       mediaType: .video,
                                       url: "https://player.vimeo.com/video/25808333?title=0&byline=0&portrait=0",
                                       hdUrl: "",
                                       thumbnailUrl: "")
        
        // When
        mediaViewer.mediaItem = mediaItem
        
        // Then
        XCTAssertFalse(mediaViewer.webPlayerView.isHidden)
        XCTAssertTrue(mediaViewer.imageView.isHidden)
        XCTAssertTrue(mediaViewer.youTublePlayerView.isHidden)
    }
    
    func testLoadAsyncRemoteImage() {
        // Given
        let mediaItem = CosmicSnapshot(title: "Test Image",
                                       dateText: "2024-08-14",
                                       explanation: "Test Description",
                                       mediaType: .image,
                                       url: "",
                                       hdUrl: "https://example.com/image.jpg",
                                       thumbnailUrl: "")
        
        // When
        mediaViewer.loadAsyncRemote(image: mediaItem)
        
        // Then
        XCTAssertFalse(mediaViewer.imageView.isHidden)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}




