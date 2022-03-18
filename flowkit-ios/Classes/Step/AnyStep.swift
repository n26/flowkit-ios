//
// Created by Alex Martinez on 14/12/21.
//

import Foundation

struct AnyStep<STEP: StepProtocol>: StepProtocol, Equatable, Hashable {
    let stepRaw: STEP

    var id: String {
        stepRaw.id
    }

    var type: String {
        stepRaw.type
    }

    var displayConditions: [STEP.DISPLAY_CONDITIONS]? {
        stepRaw.displayConditions
    }

    var contentDecoder: Decoder {
        stepRaw.contentDecoder
    }

    var nextSteps: [NextStep<STEP.NEXTSTEP_CONDITIONS>]?

    init(_ stepInfo: STEP) {
        stepRaw = stepInfo
        nextSteps = stepInfo.nextSteps
    }

    func hash(into hasher: inout Hasher) {
        id.hash(into: &hasher)
    }

    static func == (lhs: AnyStep<STEP>, rhs: AnyStep<STEP>) -> Bool {
        lhs.id == rhs.id
            && lhs.type == rhs.type
            && lhs.nextSteps == rhs.nextSteps
    }
}
