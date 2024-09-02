//
//  Date+Custom.swift
//  CosmicView
//
//  Created by Venkata Sivannarayana Golla on 01/09/24.
//

import Foundation

extension Date {
    
    /// Converts the date to a string formatted in the CosmicSnapshot date format.
    ///
    /// The CosmicSnapshot date format is `"yyyy-MM-dd"`. This method uses a `DateFormatter` to convert the `Date` instance into a string that follows this format.
    ///
    /// - Returns: A `String` representing the date formatted according to the input date format.
    func cosmicDateAsText() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: self)
    }
    
    /// Converts a string in the CosmicSnapshot date format to a `Date` object.
    ///
    /// The CosmicSnapshot date format is `"yyyy-MM-dd"`. This method uses a `DateFormatter` to parse a date string and convert it into a `Date` object.
    ///
    /// - Parameter dateString: A `String` representing a date in the CosmicSnapshot date format (`"yyyy-MM-dd"`).
    /// - Returns: An optional `Date` object created from the provided date string. Returns `nil` if the string does not match the expected format.
    func cosmicDate(from dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: dateString)
    }
}
