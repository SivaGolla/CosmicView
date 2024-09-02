//
//  String+Custom.swift
//  CosmicView
//
//  Created by Venkata Sivannarayana Golla on 01/09/24.
//

import Foundation

/// Extension for `String` to add YouTube URL validation and extraction of YouTube video ID.
extension String {
    
    /// Validates whether the string is a valid YouTube URL.
    ///
    /// - Returns: A Boolean value indicating whether the string is a valid YouTube URL.
    ///
    func isValidYouTubeUrlPath() -> Bool {
        // Regular expression pattern to match YouTube video URLs.
        // This covers various formats including short URLs, full URLs with different paths (embed, watch, etc.), and optional query parameters.
        let ytRegex = "(https?:\\/\\/)?(?:m\\.|www\\.)?(?:youtu\\.be\\/|youtube\\.com\\/(?:embed\\/|v\\/|watch\\?v=|watch\\?.+&v=))((\\w|-){11})(\\?\\S*)?$"
        
        // Use NSPredicate to evaluate if the string matches the YouTube URL pattern.
        let predicate = NSPredicate(format: "SELF MATCHES %@", ytRegex)
        return predicate.evaluate(with: self)
    }
    
    /// Extracts the YouTube video ID from a valid YouTube URL string.
    ///
    /// - Returns: A string containing the YouTube video ID if it exists, or `nil` if it cannot be found.
    /// 
    var youtubeID: String? {
        // Regular expression pattern to extract the video ID from various possible YouTube URL formats.
        // The pattern looks for the video ID after common YouTube URL components like 'v/', 'be/', '?v=', or 'embed/'.
        let pattern = "((?<=(v|V)/)|(?<=be/)|(?<=(\\?|\\&)v=)|(?<=embed/))([\\w-]++)"
        
        // Create a regular expression object from the pattern.
        let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        let range = NSRange(location: 0, length: count)
        
        // Search for the first match of the video ID in the string.
        guard let result = regex?.firstMatch(in: self, range: range) else {
            // Return `nil` if no match is found.
            return nil
        }
        
        // Extract the video ID from the matched range and return it as a string.
        return (self as NSString).substring(with: result.range)
    }
}

