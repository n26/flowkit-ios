//
//  Created by Guillem on 22/7/22.
//

import Foundation
import FlowKit

struct SignUpStepFactory: StepFactory {
    typealias OUTPUT = FlowOutputEmptyDefinition
    typealias STEP = Step

    func makeHandler(for stepRawType: String) -> AnyStepHandler<STEP, OUTPUT>? {
        switch stepRawType {
        case "TEXT_INPUT": return AnyStepHandler(textInputStepHandler())
        case "INFO": return AnyStepHandler(infoStepHandler())
        case "SUMMARY": return AnyStepHandler(flowSummaryStepHandler())
        default: return nil
        }
    }

    private func textInputStepHandler() -> StepHandler<TextInputStepHandlerDefinition> {
        .create { _, stepContent, navigation, _, completion in
            TextInputWireframe.push(on: navigation, content: stepContent, completion: completion)
        }
    }

    private func infoStepHandler() -> StepHandler<InfoStepHandlerDefinition> {
        .createWithEmptyOutput { _, stepContent, navigation, _, completion in
            InfoWireframe.push(on: navigation, content: stepContent, completion: completion)
        }
    }

    private func flowSummaryStepHandler() -> StepHandler<FlowSummaryStepHandlerDefinition> {
        .createWithEmptyOutput { _, _, navigation, currentOutput, completion in
            FlowSummaryWireframe.push(on: navigation, flowId: currentOutput.flowId, currentOutput: currentOutput.rawData, completion: completion)
        }
    }
}
