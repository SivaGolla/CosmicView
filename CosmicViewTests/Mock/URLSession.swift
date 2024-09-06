//
//  URLSession.swift
//  CosmicView-Dev
//
//  Created by Venkata Sivannarayana Golla on 03/09/24.
//

import Foundation

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

//class LoadingViewMock: LoadingView {
//    var didStartLoading = false
//    
//    override class func start() {
//        didStartLoading = true
//    }
//    
//    override class func stop() {
//        didStartLoading = false
//    }
//}
