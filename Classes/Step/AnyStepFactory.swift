//
// Created by Alex Martinez on 23/2/22.
//

import Foundation

///
/// Erasure type of StepFactory
///
public struct AnyStepFactory<STEP: StepProtocol, OUTPUT: FlowOutputDefinition>: StepFactory {
    private let _makeHandler: (String) -> AnyStepHandler<STEP, OUTPUT>?

    public init<T: StepFactory>(_ factory: T) where T.OUTPUT == OUTPUT, T.STEP == STEP {
        _makeHandler = factory.makeHandler
    }

    public func makeHandler(for stepRawType: String) -> AnyStepHandler<STEP, OUTPUT>? {
        _makeHandler(stepRawType)
    }
}
