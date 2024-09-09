//
//  URLSession.swift
//  CosmicView-Dev
//
//  Created by Venkata Sivannarayana Golla on 03/09/24.
//

import Foundation
import UIKit

class UserSession {
    static var activeSession: URLSessionProtocol = MockURLSession()
}

extension MediaCacheManager {
    var imageCacheCount: Int {
        return imageCache.countLimit
    }
}

extension CosmicSnapshot: Equatable {
    static func == (lhs: CosmicSnapshot, rhs: CosmicSnapshot) -> Bool {
        return lhs.title == rhs.title && lhs.dateText == rhs.dateText && lhs.explanation == rhs.explanation && lhs.mediaType == rhs.mediaType && lhs.url == rhs.url && lhs.hdUrl == rhs.hdUrl && lhs.thumbnailUrl == rhs.thumbnailUrl
    }
}

class LoadingView {
    
    static var didStartLoading = false
    
    public static func start(style: UIActivityIndicatorView.Style = .large, baseColor: UIColor = .gray) {
        didStartLoading = true
    }
    
    public static func stop() {
        didStartLoading = false
    }
}

