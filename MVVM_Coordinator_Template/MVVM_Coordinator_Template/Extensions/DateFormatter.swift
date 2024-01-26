//
//  DateFormatter.swift
//  MyTMDB
//
//  Created by Bo Zhang on 2024-01-05.
//

import Foundation

extension DateFormatter {
    
    /// Formats a date in UTC as specified in ISO8601, but leaving out the time zone information
    /// (meaning the resulting string _assumes_ UTC)
    static let basicISO8601DateFormatter : DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = .gmt
        return formatter
    }()
    
    /// Formats a date as specified in ISO 8601
    static let customeISO8601DateFormatter : DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = .gmt
        return formatter
    }()
    
    /// Formats a date in UTC as YYYY-MM-DD
    static let dateOnlyJSONFormatter : DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = .gmt
        return formatter
    }()
    
    /// Formats a date in UTC, showing only the date parts, not the time parts.
    static let dateOnlyDisplayFormatter : DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.timeZone = .gmt
        return formatter
    }()
    
    static let monthAndYearFormatter : DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = .gmt
        formatter.setLocalizedDateFormatFromTemplate("yMMMM")
        return formatter
    }()
    
}
