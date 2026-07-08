//
//  StepHandler+Async.swift
//  FlowKit
//
//  Additive async/await authoring API for step handlers.
//
//  Design: the completion-based `perform` closure remains the canonical internal
//  representation stored by `StepHandler`. These async factories adapt an
//  `async` closure *into* that completion form via a `Task`, so the engine's
//  step-chaining is unchanged and every existing completion-based handler,
//  factory and test keeps working with identical semantics.
//
//  Gated to iOS 13 (Swift Concurrency runtime floor) to preserve the package's
//  iOS 12 deployment target for the existing completion API.
//

import Foundation
import UIKit

@available(iOS 13.0, *)
public extension StepHandler {
    /// Async counterpart of ``create(shouldBeDisplayed:perform:)``.
    ///
    /// The `perform` closure returns the step output instead of invoking a
    /// completion. Overload resolution disambiguates from the completion-based
    /// `create` by the closure's arity (4 params, no trailing completion) and
    /// its `async` effect.
    static func create<STEP_DEFINITION: StepHandlerDefinition>(
        shouldBeDisplayed: ((_ stepContent: STEP_DEFINITION.CONTENT, _ displayConditions: [DisplayConditionProtocol]?, _ currentFlowOutput: FlowOutput<STEP_DEFINITION.FLOW_OUTPUT>) -> Bool)? = nil,
        perform: @escaping (_ stepInfo: STEP_DEFINITION.STEP, _ stepContent: STEP_DEFINITION.CONTENT, _ navigation: UINavigationController, _ currentFlowOutput: FlowOutput<STEP_DEFINITION.FLOW_OUTPUT>) async -> STEP_DEFINITION.STEP_OUTPUT?
    ) -> StepHandler<STEP_DEFINITION> {
        .create(
            shouldBeDisplayed: shouldBeDisplayed,
            perform: { stepInfo, stepContent, navigation, currentFlowOutput, completion in
                Task { @MainActor in
                    let output = await perform(stepInfo, stepContent, navigation, currentFlowOutput)
                    completion(output)
                }
            }
        )
    }

    /// Async counterpart of ``createWithEmptyOutput(shouldBeDisplayed:perform:)``
    /// for steps that produce no output.
    static func createWithEmptyOutput<STEP_DEFINITION: StepHandlerDefinition>(
        shouldBeDisplayed: ((_ stepContent: STEP_DEFINITION.CONTENT, _ displayConditions: [DisplayConditionProtocol]?, _ currentFlowOutput: FlowOutput<STEP_DEFINITION.FLOW_OUTPUT>) -> Bool)? = nil,
        perform: @escaping (_ stepInfo: STEP_DEFINITION.STEP, _ stepContent: STEP_DEFINITION.CONTENT, _ navigation: UINavigationController, _ currentFlowOutput: FlowOutput<STEP_DEFINITION.FLOW_OUTPUT>) async -> Void
    ) -> StepHandler<STEP_DEFINITION> where STEP_DEFINITION.STEP_OUTPUT == StepOutputEmpty {
        .createWithEmptyOutput(
            shouldBeDisplayed: shouldBeDisplayed,
            perform: { stepInfo, stepContent, navigation, currentFlowOutput, completion in
                Task { @MainActor in
                    await perform(stepInfo, stepContent, navigation, currentFlowOutput)
                    completion()
                }
            }
        )
    }
}
