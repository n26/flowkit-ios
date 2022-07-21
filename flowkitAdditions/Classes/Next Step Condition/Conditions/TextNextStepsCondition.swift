//
// Created by Alex Martinez on 14/10/2020.
//

import FlowKit
import Foundation

struct TextNextStepsCondition: Codable, Equatable {
    let answerStepId: String
    let values: [String]
}

extension TextNextStepsCondition: StepConditionMatching {
    func match(input: [String: Any]) -> Bool {
        guard let valueAnswered = input[answerStepId] as? String else {
            return false
        }
        
        return values.contains(valueAnswered)
    }
}
