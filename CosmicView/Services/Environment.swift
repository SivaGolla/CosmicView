//
//  Environment.swift
//  CosmicView
//
//  Created by Venkata Sivannarayana Golla on 01/09/24.
//

import Foundation

/// An enumeration representing different environments in which the app can run.
enum Environment {
    case dev   // Development environment
    case uat   // User Acceptance Testing (UAT) environment
    case prod  // Production environment
}

extension Environment {
    
    /// A static computed property that determines the current environment based on the app's target name.
    ///
    /// The target name is retrieved from the app's Info.plist file under the key "TargetName".
    /// Depending on the target name, this property returns the corresponding `Environment` case.
    ///
    static var current: Environment {
        // Retrieve the target name from the app's Info.plist.
        let targetName = Bundle.main.infoDictionary?["TargetName"] as? String
        
        // Determine the environment based on the target name.
        switch targetName {
        case "CosmicView-Prod":
            return Environment.uat   // Maps "CosmicView-Prod" to UAT environment (This seems like a logical error; see note below).
        case "CosmicView-Uat":
            return Environment.prod  // Maps "CosmicView-Uat" to Production environment (This seems like a logical error; see note below).
        default:
            return Environment.dev   // Defaults to Development environment.
        }
    }
    
    /// A computed property that returns the base URL path for the current environment.
    ///
    /// This URL is used to make API requests to the appropriate endpoint depending on the environment.
    ///
    var baseUrlPath: String {
        switch self {
        case .prod:
            return "https://api.nasa.gov"  // Base URL for production environment.
        default:
            return "https://api.nasa.gov"  // Base URL for development and UAT environments.
        }
    }
    
    /// A computed property that returns the API key for the current environment.
    /// The API key is used to authenticate requests to the NASA APOD API.
    ///
    var apiKey: String {
        switch self {
        case .prod:
            return "xSq3ugePAFtrj2BQik6JMED9AofRhzFAmKuJIJbZ"  // API key for production environment.
        default:
            return "xSq3ugePAFtrj2BQik6JMED9AofRhzFAmKuJIJbZ"  // API key for development and UAT environments.
        }
    }
}


// MARK: All Service Endpoints
extension Environment {
    
    /// A static constant that constructs the full APOD API endpoint for the current environment.
    /// This combines the base URL and API key to create a complete URL for making requests.
    ///
    /// Ex: https://api.nasa.gov/planetary/apod?api_key=xSq3ugePAFtrj2BQik6JMED9AofRhzFAmKuJIJbZ
    ///
    static let mediaOfTheData = Environment.current.baseUrlPath + "/planetary/apod?api_key=\(Environment.current.apiKey)"
}
