//
//  CosmicSnapshot.swift
//  CosmicView
//
//  Created by Venkata Sivannarayana Golla on 01/09/24.
//

import Foundation

/// An enumeration representing the type of media associated with a cosmic snapshot.
/// This enum conforms to `Codable` to support encoding to and decoding from JSON.
///
enum MediaType: String, Codable {
    case image
    case video
}

/// A model representing a cosmic snapshot, such as those from NASA's Astronomy Picture of the Day (APOD).
/// This model conforms to `Codable` to support encoding to and decoding from JSON.
///
struct CosmicSnapshot: Codable {
    /// The title of the snapshot.
    let title: String
    
    /// The date associated with the snapshot, formatted as a string.
    let dateText: String
    
    /// A detailed explanation or description of the snapshot.
    let explanation: String
    
    /// The type of media associated with the snapshot (e.g., image or video).
    let mediaType: MediaType
    
    /// The URL where the media can be accessed.
    let url: String
    
    /// The URL for the high-definition version of the media, if available. Optional.
    let hdUrl: String?
    
    /// The URL for the thumbnail version of the media, if available. Optional.
    let thumbnailUrl: String?
    
    /// Custom keys for encoding and decoding the properties, matching the expected JSON keys.
    enum CodingKeys: String, CodingKey {
        case title                          // Maps directly to the "title" key in JSON.
        case dateText = "date"              // Maps to the "date" key in JSON.
        case explanation                    // Maps directly to the "explanation" key in JSON.
        case mediaType = "media_type"       // Maps to the "media_type" key in JSON.
        case url                            // Maps directly to the "url" key in JSON.
        case hdUrl = "hdurl"                // Maps to the "hdurl" key in JSON.
        case thumbnailUrl = "thumbnail_url" // Maps to the "thumbnail_url" key in JSON.
    }
}
