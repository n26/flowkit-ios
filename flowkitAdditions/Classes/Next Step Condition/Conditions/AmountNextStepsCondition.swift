//
// Created by Alex Martinez on 14/10/2020.
//

import N26FlowKitCore

struct AmountNextStepsCondition: Decodable, Equatable {
    let answerStepId: String
    let minAmount: Double?
    let maxAmount: Double?
}

extension AmountNextStepsCondition: StepConditionMatching {
    func match(input: [String: Any]) -> Bool {
        guard let amountAnswered = input[answerStepId] as? Double else {
            return false
        }
        
        if let min = minAmount {
            guard amountAnswered >= min else { return false }
        }
        
        if let max = maxAmount {
            guard amountAnswered <= max else { return false }
        }
        
        return true
    }
}
