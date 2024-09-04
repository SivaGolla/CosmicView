//
//  AsyncMediaProvider.swift
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
    ///   - session: The URLSession instance used to perform network operations, conforming to the `URLSessionProtocol` for testability.
    ///   - placeholder: An optional placeholder image to return if the image cannot be loaded.
    ///   - completion: A closure that returns the loaded `UIImage` or the placeholder image if loading fails.
    ///
    static func loadImage(urlPath: String, session:URLSessionProtocol, placeholder: UIImage?, completion: @escaping ((UIImage?) -> Void)) {
        // If the URL path is empty, return the placeholder image immediately.
        guard !urlPath.isEmpty else {
            completion(placeholder)
            return
        }
        
        // Check if the image is already cached in the image cache.
        // If a cached image is found, return it immediately via the completion handler.
        if let cachedImage = MediaCacheManager.shared.loadImage(forKey: urlPath) {
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
        let task = session.dataTask(with: imageUrl) { data, response, error in
            // Ensure data was received, there were no errors, and that the data can be converted into a UIImage.
            guard let data = data, error == nil, let image = UIImage(data: data) else {
                // If any of the above conditions fail, return the placeholder image.
                completion(placeholder)
                return
            }
            
            // Cache the successfully downloaded image using the URL path as the key.
            MediaCacheManager.shared.saveImage(image, forKey: urlPath)
            
            // Return the downloaded image via the completion handler.
            completion(image)
        }
        
        // Start the image download task.
        task.resume()
    }
    
    /// Loads an image from a URL asynchronously.
    /// If the image is cached, it is returned immediately. Otherwise, the image is downloaded from the URL.
    ///
    /// - Parameters:
    ///   - urlPath: The string URL path from which to load the image.
    ///   - session: The URLSession instance used to perform network operations, conforming to the `URLSessionProtocol` for testability.
    ///   - placeholder: An optional placeholder image to return if the image cannot be loaded.
    /// - Returns: Returns the loaded `UIImage` or the placeholder image if loading fails.
    ///
    @MainActor
    static func loadImage(urlPath: String, session:URLSessionProtocol,  placeholder: UIImage?) async throws -> UIImage? {
        // If the URL path is empty, return the placeholder image immediately.
        guard !urlPath.isEmpty else {
            return placeholder
        }
        
        // Check if the image is already cached in the image cache.
        // If a cached image is found, return it immediately via the completion handler.
        if let cachedImage = MediaCacheManager.shared.loadImage(forKey: urlPath) {
            return cachedImage
        }
        
        // Attempt to create a URL object from the provided URL path string.
        // If the URL is invalid (e.g., malformed), return the placeholder image.
        guard let imageUrl = URL(string: urlPath) else {
            return placeholder
        }
                
        // Use `URLSession` to asynchronously fetch the image data from the specified URL.
        let (data, response) = try await session.data(from: imageUrl, delegate: nil)
        
        // Ensure the response is an HTTPURLResponse.
        // Handle the response based on the HTTP status code and is in successful status code range
        guard let httpResponse = response as? HTTPURLResponse,
              (200...300).contains(httpResponse.statusCode) else {
            return placeholder
        }
        
        // Ensure data was received, there were no errors, and that the data can be converted into a UIImage.
        guard let image = UIImage(data: data) else {
            // If any of the above conditions fail, return the placeholder image.
            return placeholder
        }
        
        // Cache the successfully downloaded image using the URL path as the key.
        MediaCacheManager.shared.saveImage(image, forKey: urlPath)
        
        // Return the downloaded image via the completion handler.
        return image
    }
}

extension AsyncMedia {
    
    /// Asynchronously downloads video data from a specified URL and returns the video content as a string.
    /// - Parameters:
    ///   - urlPath: The URL string of the video to be downloaded.
    ///   - completion: A closure that is called when the download is complete, containing the video content as a string or an error if the download fails.
    ///
    static func loadVideo(urlPath: String, session:URLSessionProtocol, completion: @escaping ((String?) -> Void)) {
        
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
