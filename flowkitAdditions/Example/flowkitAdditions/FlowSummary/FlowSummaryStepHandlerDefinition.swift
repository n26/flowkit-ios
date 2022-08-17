//
//  Created by Guillem on 23/7/22.
//

import Foundation
import FlowKit

struct FlowSummaryStepHandlerDefinition: StepHandlerDefinition {
    typealias CONTENT = StepEmptyContentInput
    typealias STEP_OUTPUT = StepOutputEmpty
    typealias FLOW_OUTPUT = FlowOutputEmptyDefinition
    typealias STEP = Step
    static let registerOutputKeyPath: KeyPath<FLOW_OUTPUT, STEP_OUTPUT>? = nil
}
