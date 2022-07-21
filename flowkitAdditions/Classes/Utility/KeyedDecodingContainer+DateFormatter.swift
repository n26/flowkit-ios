//
//  KeyedDecodingContainer+DateFormatter.swift
//  flowkit-ios
//
//  Created by Giulio Lombardo  on 28/04/22.
//

import Foundation

extension KeyedDecodingContainer {
    func decode(
        using dateFormatter: DateFormatter,
        forKey key: KeyedDecodingContainer<K>.Key
    ) throws -> Date {
        let stringValue = try self.decode(String.self, forKey: key)
        
        guard let date = dateFormatter.date(from: stringValue) else {
            throw DecodingError.dataCorruptedError(
                forKey: key,
                in: self,
                debugDescription: "Date string does not match format expected by formatter."
            )
        }

        return date
    }
}
