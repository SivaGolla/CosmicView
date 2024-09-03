//
//  AsyncMedia.swift
//  CosmicView
//
//  Created by Venkata Sivannarayana Golla on 01/09/24.
//

import Foundation
import UIKit

/// A utility class for asynchronously loading images from a URL.
/// This class supports image caching to improve performance and reduce network usage.
class AsyncMedia {
    
    /// Loads an image from a URL asynchronously.
    /// If the image is cached, it is returned immediately. Otherwise, the image is downloaded from the URL.
    ///
    /// - Parameters:
    ///   - urlPath: The string URL path from which to load the image.
    ///   - placeholder: An optional placeholder image to return if the image cannot be loaded.
    ///   - completion: A closure that returns the loaded `UIImage` or the placeholder image if loading fails.
    ///
    static func loadImage(urlPath: String, placeholder: UIImage?, completion: @escaping ((UIImage?) -> Void)) {
        // If the URL path is empty, return the placeholder image immediately.
        guard !urlPath.isEmpty else {
            completion(placeholder)
            return
        }
        
        // Check if the image is already cached in the image cache.
        // If a cached image is found, return it immediately via the completion handler.
        if let cachedImage = MediaCache.shared.loadImage(forKey: urlPath) {
            completion(cachedImage)
            return
        }
        
        // Attempt to create a URL object from the provided URL path string.
        // If the URL is invalid (e.g., malformed), return the placeholder image.
        guard let imageUrl = URL(string: urlPath) else {
            completion(placeholder)
            return
        }
        
        // Create a data task to download the image from the specified URL.
        let task = URLSession.shared.dataTask(with: imageUrl) { data, response, error in
            // Ensure data was received, there were no errors, and that the data can be converted into a UIImage.
            guard let data = data, error == nil, let image = UIImage(data: data) else {
                // If any of the above conditions fail, return the placeholder image.
                completion(placeholder)
                return
            }
            
            // Cache the successfully downloaded image using the URL path as the key.
            MediaCache.shared.saveImage(image, forKey: urlPath)
            
            // Return the downloaded image via the completion handler.
            completion(image)
        }
        
        // Start the image download task.
        task.resume()
    }
}

extension AsyncMedia {
    
    /// Asynchronously downloads video data from a specified URL and returns the video content as a string.
    /// - Parameters:
    ///   - urlPath: The URL string of the video to be downloaded.
    ///   - completion: A closure that is called when the download is complete, containing the video content as a string or an error if the download fails.
    ///
    static func loadVideo(urlPath: String, completion: @escaping ((String?) -> Void)) {
        
        // Attempt to create a URL object from the provided string.
        // If the URL string is invalid, return with `nil` for both the string and error.
        guard let requestURL = URL(string: urlPath) else {
            completion(nil)
            return
        }
        
        // Create a download task to download the video from the URL.
        let task = URLSession.shared.downloadTask(with: requestURL) { localURL, urlResponse, error in
            
            // Switch to the main thread to handle UI updates or any other main-thread operations.
            DispatchQueue.main.async {
                
                // If an error occurred during the download, return the error in the completion handler.
                if error != nil {
                    completion(nil)
                    return
                }
                
                // Check if the video was downloaded successfully and is available at `localURL`.
                if let localURL = localURL {
                    // Attempt to read the contents of the downloaded file as a string.
                    if let string = try? String(contentsOf: localURL) {
                        // Print the video content (for debugging purposes).
                        print(string)
                        
                        // Return the video content as a string in the completion handler.
                        completion(string)
                    }
                }
                
                // Note: If the content needs to be saved or further processed, additional code should be added here.
            }
        }
        
        // Start the download task.
        task.resume()
    }
}
