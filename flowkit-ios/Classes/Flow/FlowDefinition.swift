//
// Created by Alex Martinez on 15/12/21.
//

import Foundation

///
/// The flow definition that your concrete flow has to define
/// - Associated types
///     - OUTPUT: Define the flow output
///     - STEP: Define the Step implementation
/// - Tag: FlowDefinition
/// ````
///     struct ConcreteFlowDefinition: FlowDefinition {
///         typealias OUTPUT = ConcreteFlowOutput
///         typealias STEP = ConcreteStepImp
///     }
/// ````
public protocol FlowDefinition {
    associatedtype OUTPUT: FlowOutputDefinition
    associatedtype STEP: StepProtocol & Decodable
}
