//
// Created by Alex Martinez on 23/2/22.
//

import Foundation

// sourcery: AutoMockable
// sourcery: associatedtype = "OUTPUT: FlowOutputDefinition"
// sourcery: associatedtype = "STEP: StepProtocol"
public protocol StepFactory {
    associatedtype OUTPUT: FlowOutputDefinition
    associatedtype STEP: StepProtocol
    func makeHandler(for stepRawType: String) -> AnyStepHandler<STEP, OUTPUT>?
}
