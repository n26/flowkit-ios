//
// Created by Alex Martinez on 14/10/2020.
//

import Foundation

public struct NextStep<STEP_CONDITIONS: NextStepConditionProtocol>: Decodable, Equatable {
    let nextStepId: String
    let conditions: [STEP_CONDITIONS]?

    var isDefaultStep: Bool {
        conditions?.isEmpty ?? true
    }

    public init(
        nextStepId: String,
        conditions: [STEP_CONDITIONS]?
    ) {
        self.nextStepId = nextStepId
        self.conditions = conditions
    }
}
