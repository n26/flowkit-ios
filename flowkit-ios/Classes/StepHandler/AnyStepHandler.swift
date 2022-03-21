//
// Created by Alex Martinez on 10/11/21.
//

import Foundation
import UIKit

///
///
/// Erasure type of StepHandlerT
///
public struct AnyStepHandler<STEP: StepProtocol, FLOW_OUTPUT: FlowOutputDefinition>: StepHandlerT {
    private let _shouldBeDisplayed: (Decoder, [DisplayConditionProtocol]?, CurrentFlowOutput) -> Bool
    private let _perform: (STEP, Decoder, UINavigationController, CurrentFlowOutput, AnyKeyPath?, @escaping (Any?) -> Void) throws -> Void
    private let _registerOutputKeyPath: AnyKeyPath?

    public init<T>(_ handler: StepHandler<T>) where T.FLOW_OUTPUT == FLOW_OUTPUT, T.STEP == STEP {
        _shouldBeDisplayed = handler.shouldBeDisplayed
        _perform = handler.perform
        _registerOutputKeyPath = handler.registerOutputKeyPath
    }

    public func shouldBeDisplayed(contentDecoder: Decoder, displayConditions: [DisplayConditionProtocol]?, currentFlowOutput: CurrentFlowOutput) -> Bool {
        _shouldBeDisplayed(contentDecoder, displayConditions, currentFlowOutput)
    }

    public func perform(stepInfo: STEP, contentDecoder: Decoder, viewController: UINavigationController, currentFlowOutput: CurrentFlowOutput, registerOutputType: AnyKeyPath?, completion: @escaping (Any?) -> Void) throws {
        try _perform(stepInfo, contentDecoder, viewController, currentFlowOutput, registerOutputType, completion)
    }

    public var registerOutputKeyPath: AnyKeyPath? {
        _registerOutputKeyPath
    }
}

extension AnyStepHandler {
    public init<T>(handler: StepHandler<T>) where T.FLOW_OUTPUT == FlowOutputEmptyDefinition, T.STEP == STEP {
        _shouldBeDisplayed = handler.shouldBeDisplayed
        _perform = handler.perform
        _registerOutputKeyPath = handler.registerOutputKeyPath
    }
}
