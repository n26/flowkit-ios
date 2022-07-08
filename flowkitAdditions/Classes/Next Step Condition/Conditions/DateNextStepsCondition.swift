//
// Created by Alex Martinez on 14/10/2020.
//

import FlowKit

struct DateNextStepsCondition: Decodable, Equatable {
    enum CodingKeys: String, CodingKey {
        case minDate
        case maxDate
        case answerStepId
    }
    
    let answerStepId: String
    let minDate: Date?
    let maxDate: Date?
    
    init(answerStepId: String, minDate: Date?, maxDate: Date?) {
        self.answerStepId = answerStepId
        self.minDate = minDate
        self.maxDate = maxDate
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.answerStepId = try container.decode(
            String.self,
            forKey: .answerStepId
        )
        
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

extension DateNextStepsCondition: StepConditionMatching {
    func match(input: [String: Any]) -> Bool {
        guard let dateAnswered = input[answerStepId] as? Date else {
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
