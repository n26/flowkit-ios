//
//  Created by Guillem on 22/7/22.
//

import Foundation
import FlowKit

struct TextInputStepHandlerDefinition: StepHandlerDefinition {
    typealias CONTENT = TextInputContent
    typealias STEP_OUTPUT = String
    typealias FLOW_OUTPUT = FlowOutputEmptyDefinition
    typealias STEP = Step
    static let registerOutputKeyPath: KeyPath<FLOW_OUTPUT, STEP_OUTPUT>? = nil
}
