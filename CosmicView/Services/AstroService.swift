//
//  AstroService.swift
//  CosmicView
//
//  Created by Venkata Sivannarayana Golla on 01/09/24.
//

import Foundation

/// Service for interacting with the Media of the Day API.
///
class AstroService: ServiceProviding {
    
    // MARK: - Properties
    
    /// Search parameters for the Media of the Day request.
    var urlSearchParams: CosmicSnapshotRequestModel?
    
    // MARK: - ServiceProviding Methods
    
    /// Constructs a Request object based on the search parameters.
    /// - Returns: A Request object, or nil if the URL path cannot be constructed.
    func makeRequest() -> Request? {
        
        // Base URL for the Media of the Day API endpoint.
        var reqUrlPath = Environment.mediaOfTheData
        
        // Append query parameters to the base URL if they exist.
        if let requestParams = urlSearchParams {
            
            if let count = requestParams.count, count > 0 {
                // Handle count parameter if provided.
                // If this is specified then count randomly chosen images will be returned. Cannot be used with date or start_date and end_date.
                
                reqUrlPath = reqUrlPath + "&count=\(count)"
                
            } else {
                
                if let date = requestParams.date {
                    // Handle date parameter if it exists.
                    // The date of the APOD image to retrieve
                    
                    reqUrlPath = reqUrlPath + "&date=\(date.cosmicDateAsText())"
                    
                } else if let startDate = requestParams.startDate {
                    // Handle date range if both startDate and endDate are provided.
                    
                    // The start of a date range, when requesting date for a range of dates. Cannot be used with date.
                    reqUrlPath = reqUrlPath + "&start_date=\(startDate.cosmicDateAsText())"
                    
                    if let endDate = requestParams.endDate {
                        
                        // The end of the date range, when used with start_date.
                        reqUrlPath = reqUrlPath + "&end_date=\(endDate.cosmicDateAsText())"
                    }
                }
            }
            
            // Handle thumbs parameter if provided.
            if let thumbs = requestParams.thumbs {
                
                // Return the URL of video thumbnail. If an APOD is not a video, this parameter is ignored.
                reqUrlPath = reqUrlPath + "&thumbs=\(thumbs)"
            }
        }
        
        // Create and return a Request object with the constructed URL path.
        let request = Request(
            path: reqUrlPath,
            method: .get,
            contentType: "application/json",
            headerParams: nil,
            type: .picOfTheDay,
            body: nil
        )
        return request
    }
    
    /// Executes a network request and returns the result.
    /// - Parameter completion: A closure to handle the result of the network request.
    /// - Note: This method is generic and can handle any Decodable type.
    func fetch<T>(completion: @escaping (Result<T, NetworkError>) -> Void) where T : Decodable {
        
        // Construct the request using makeRequest().
        guard let request = makeRequest() else {
            completion(.failure(.invalidUrl))
            return
        }
        
        // Execute the request using NetworkManager.
        NetworkManager(session: UserSession.activeSession).execute(request: request) { result in
            DispatchQueue.main.async {
                // Call the completion handler with the result of the request.
                completion(result)
            }
        }
    }
}
