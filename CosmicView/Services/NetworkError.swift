//
//  NetworkError.swift
//  CosmicView
//
//  Created by Venkata Sivannarayana Golla on 01/09/24.
//

import Foundation

/// Enum representing the various network-related errors that can occur during API requests.
enum NetworkError: Error {
    
    /// Indicates that the URL provided for the request was invalid.
    /// - Example: The URL string could not be converted to a `URL` object.
    case invalidUrl
    
    /// Indicates that the request was malformed or the server could not understand it.
    /// - Example: Sending incorrect parameters in the request body.
    case badRequest
    
    /// Indicates that the server encountered an internal error.
    /// - Example: The server is misconfigured or has a bug causing it to fail.
    case internalServerError
    
    /// Indicates that the request timed out due to network issues or server unresponsiveness.
    /// - Example: The server took too long to respond to the request.
    case requestTimedOut
    
    /// Indicates that there was an error while parsing the response data.
    /// - Example: The response was not in the expected format or was corrupted.
    case parsingError
    
    /// Indicates that an image could not be created from the downloaded data.
    /// - Example: The downloaded data was supposed to be an image, but the conversion failed.
    case imageCreationError
    
    /// Indicates that the request did not return any data.
    /// - Example: The server response was empty when data was expected.
    case noData
}
