//
// Created by Alex Martinez on 23/2/22.
//

import Foundation

///
/// CONTENT: Step content input type. If the step doesn't need content you should use **StepEmptyContentInput**.
/// STEP_OUTPUT: The output type produced by the step. If your step doesn't produce any outputs you should use **Never**.
/// FLOW_OUTPUT: Context to use as shared data between steps. If your step doesn't need any context you should use **Never**.
///
public protocol StepHandlerDefinition {
    associatedtype CONTENT: Decodable
    associatedtype STEP_OUTPUT: StepOutput
    associatedtype FLOW_OUTPUT: FlowOutputDefinition
    associatedtype STEP: StepProtocol
    static var registerOutputKeyPath: KeyPath<FLOW_OUTPUT, STEP_OUTPUT>? { get }
}

public extension StepHandlerDefinition where STEP_OUTPUT == StepOutputEmpty {
    static var registerOutputKeyPath: KeyPath<FLOW_OUTPUT, STEP_OUTPUT>? {
        nil
    }
}
