//
// Created by Alex Martinez on 11/06/2020.
//

import Foundation

public struct DateDisplayCondition: Decodable, Equatable {
    enum CodingKeys: String, CodingKey {
        case minDate
        case maxDate
    }
    
    public let minDate: Date?
    public let maxDate: Date?
    
    public init(minDate: Date?, maxDate: Date?) {
        self.minDate = minDate
        self.maxDate = maxDate
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        do {
            self.maxDate = try container.decode(
                using: .ISODateOnly,
                forKey: .maxDate
            )
        } catch DecodingError.keyNotFound(_, _) {
            self.maxDate = nil
        } catch {
            throw error
        }
        
        do {
            self.minDate = try container.decode(
                using: .ISODateOnly,
                forKey: .minDate
            )
        } catch DecodingError.keyNotFound(_, _) {
            self.minDate = nil
        } catch {
            throw error
        }
    }
}

extension DateDisplayCondition: Matching {
    func match(stepId: String, input: [String: Any]) -> Bool {
        guard let dateAnswered = input[stepId] as? Date else {
            return false
        }
        
        if let min = minDate {
            guard dateAnswered >= min else { return false }
        }
        
        if let max = maxDate {
            guard dateAnswered <= max else { return false }
        }
        
        return true
    }
}
