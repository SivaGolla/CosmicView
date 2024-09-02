//
//  CosmicSnapshotRequestModel.swift
//  CosmicView
//
//  Created by Venkata Sivannarayana Golla on 01/09/24.
//

import Foundation

/// A model representing the request parameters for fetching cosmic snapshots.
/// This model conforms to `Codable` to support encoding to and decoding from JSON.
///
struct CosmicSnapshotRequestModel: Decodable {
    /// A unique identifier for the request.
    let id: String
    
    /// The specific date for which the snapshot is requested. Optional.
    var date: Date? = nil
    
    /// The start date for a range of dates for which snapshots are requested. Optional.
    var startDate: Date? = nil
    
    /// The end date for a range of dates for which snapshots are requested. Optional.
    var endDate: Date? = nil
    
    /// The number of snapshots to retrieve. Optional.
    var count: Int? = nil
    
    /// A boolean flag indicating whether to include thumbnail images in the response. Optional.
    var thumbs: Bool? = true
    
    /// Custom keys for encoding and decoding the properties, matching the expected JSON keys.
    enum CodingKeys: String, CodingKey {
        case id                         // Maps directly to the "id" key in JSON.
        case date = "date"              // Maps to the "date" key in JSON.
        case startDate = "start_date"   // Maps to the "start_date" key in JSON.
        case endDate = "end_date"       // Maps to the "end_date" key in JSON.
        case count                      // Maps directly to the "count" key in JSON.
        case thumbs = "thumbs"          // Maps to the "thumbs" key in JSON.
    }
}
