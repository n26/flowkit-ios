//
// Created by Alex Martinez on 23/2/22.
//

import Foundation

/// Step Factory interface
/// - Associated types
///     - OUTPUT: Flow output type
///     - STEP: Flow step type
///  - Important: The Step factory associated types must match with the flow definition [FlowDefinition](x-source-tag://FlowDefinition)
/// - Tag: StepFactory
public protocol StepFactory {
    associatedtype OUTPUT: FlowOutputDefinition
    associatedtype STEP: StepProtocol
    func makeHandler(for stepRawType: String) -> AnyStepHandler<STEP, OUTPUT>?
}
