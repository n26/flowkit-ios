//
//  Created by Guillem on 22/7/22.
//

import Foundation
import FlowKit

struct InfoStepHandlerDefinition: StepHandlerDefinition {
    typealias CONTENT = InfoContent
    typealias STEP_OUTPUT = StepOutputEmpty
    typealias FLOW_OUTPUT = FlowOutputEmptyDefinition
    typealias STEP = Step
    static let registerOutputKeyPath: KeyPath<FLOW_OUTPUT, STEP_OUTPUT>? = nil
}
