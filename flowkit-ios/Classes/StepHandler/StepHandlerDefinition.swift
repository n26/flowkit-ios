//
// Created by Alex Martinez on 23/2/22.
//

import Foundation

///
/// A concrete Step definition interface
/// - Associated types
///     - CONTENT: Step content input type. If the step doesn't need content you should use [StepEmptyContentInput](x-source-tag://StepEmptyContentInput).
///     - STEP_OUTPUT: The output type produced by the step. If your step doesn't produce any outputs you should use [StepOutputEmpty](x-source-tag://StepOutputEmpty).
///     - FLOW_OUTPUT: The flow output type
///     - STEP: The generic step definition
/// - Properties
///     - registerOutputKeyPath:
/// ````
///     struct ConcreteStepDefinition: StepHandlerDefinition {
///         typealias CONTENT = ConcreteFlowOutput
///         typealias STEP_OUTPUT = ConcreteFlowOutput
///         typealias FLOW_OUTPUT = ConcreteFlowOutput
///         typealias STEP = ConcreteFlowOutput
///
///         static var registerOutputKeyPath: KeyPath<FLOW_OUTPUT, STEP_OUTPUT>? {
///             return
///         }
///     }
/// ````
/// - Tag: StepHandlerDefinition
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
