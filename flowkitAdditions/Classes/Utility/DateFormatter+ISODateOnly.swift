//
//  DateFormatter+ISODateOnly.swift
//  flowkit-ios
//
//  Created by Giulio Lombardo  on 28/04/22.
//

import Foundation

extension DateFormatter {
    static var ISODateOnly: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        return formatter
    }
}
