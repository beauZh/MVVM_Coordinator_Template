//
//  JSONDecoder.swift
//  MyTMDB
//
//  Created by Bo Zhang on 2024-01-05.
//

import Foundation

extension JSONDecoder {
    
    static var mtDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .custom({ (decoder) -> Date in
            let dateString = try decoder.singleValueContainer().decode(String.self)
            guard let date = DateFormatter.customeISO8601DateFormatter.date(from: dateString) ??
                    DateFormatter.dateOnlyJSONFormatter.date(from: dateString) ??
                    DateFormatter.basicISO8601DateFormatter.date(from: dateString) else {
                throw MTError.dateNotParsableError
            }
            return date
        })
        return decoder
    }
    
}
