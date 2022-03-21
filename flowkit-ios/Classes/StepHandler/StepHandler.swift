//
// Created by Alex Martinez on 14/05/2020.
//

import Foundation
import UIKit

public protocol StepHandlerT {
    associatedtype FLOW_OUTPUT: FlowOutputDefinition
    associatedtype STEP: StepProtocol
    func shouldBeDisplayed(contentDecoder: Decoder, displayConditions: [DisplayConditionProtocol]?, currentFlowOutput: CurrentFlowOutput) -> Bool
    func perform(stepInfo: STEP, contentDecoder: Decoder, viewController: UINavigationController, currentFlowOutput: CurrentFlowOutput, registerOutputType: AnyKeyPath?, completion: @escaping (Any?) -> Void) throws
    var registerOutputKeyPath: AnyKeyPath? { get }
}

public struct StepHandler<STEP_DEFINITION: StepHandlerDefinition>: StepHandlerT {
    public typealias STEP = STEP_DEFINITION.STEP
    public typealias FLOW_OUTPUT = STEP_DEFINITION.FLOW_OUTPUT

    let shouldBeDisplayed: ((STEP_DEFINITION.CONTENT, [DisplayConditionProtocol]?, FlowOutput<STEP_DEFINITION.FLOW_OUTPUT>) -> Bool)?
    let perform: (STEP_DEFINITION.STEP, STEP_DEFINITION.CONTENT, UINavigationController, FlowOutput<STEP_DEFINITION.FLOW_OUTPUT>, @escaping (STEP_DEFINITION.STEP_OUTPUT?) -> Void) -> Void
    public let registerOutputKeyPath: AnyKeyPath?

    ///
    ///
    /// - Parameters:
    ///   - shouldBeDisplayed: Implement it to decide under which conditions the step should be displayed
    ///   - perform: Perform only executed when is the step turn. Here is when the scene is created and presented. The completion has to be called to finish the step.
    ///   - stepInfo: Step info data
    ///   - stepContent: Content input object
    ///   - navigation: Navigation controller
    ///   - currentFlowOutput: Current flow output with all the previous steps result
    ///   - output: Output value of the step
    init(shouldBeDisplayed: ((_ stepContent: STEP_DEFINITION.CONTENT, _ displayConditions: [DisplayConditionProtocol]?, _ currentFlowOutput: FlowOutput<STEP_DEFINITION.FLOW_OUTPUT>) -> Bool)? = nil,
         perform: @escaping (_ stepInfo: STEP_DEFINITION.STEP, _ stepContent: STEP_DEFINITION.CONTENT, _ navigation: UINavigationController, _ currentFlowOutput: FlowOutput<STEP_DEFINITION.FLOW_OUTPUT>, @escaping ( _ output: STEP_DEFINITION.STEP_OUTPUT?) -> Void) -> Void) {
        registerOutputKeyPath = STEP_DEFINITION.registerOutputKeyPath
        self.shouldBeDisplayed = shouldBeDisplayed
        self.perform = perform
    }

    private init(shouldBeDisplayed: ((_ stepContent: STEP_DEFINITION.CONTENT, _ displayConditions: [DisplayConditionProtocol]?, _ currentFlowOutput: FlowOutput<STEP_DEFINITION.FLOW_OUTPUT>) -> Bool)? = nil,
                 perform: @escaping (_ stepInfo: STEP_DEFINITION.STEP, _ stepContent: STEP_DEFINITION.CONTENT, _ navigation: UINavigationController, _ currentFlowOutput: FlowOutput<STEP_DEFINITION.FLOW_OUTPUT>, @escaping () -> Void) -> Void) where STEP_DEFINITION.STEP_OUTPUT == StepOutputEmpty {
        registerOutputKeyPath = nil
        self.shouldBeDisplayed = shouldBeDisplayed
        self.perform = { stepInfo, stepContent, navigation, flowOutput, completion in
            perform(stepInfo, stepContent, navigation, flowOutput) {
                completion(nil)
            }
        }
    }

    public static func create<STEP_DEFINITION: StepHandlerDefinition>(
        shouldBeDisplayed: ((_ stepContent: STEP_DEFINITION.CONTENT, _ displayConditions: [DisplayConditionProtocol]?, _ currentFlowOutput: FlowOutput<STEP_DEFINITION.FLOW_OUTPUT>) -> Bool)? = nil,
        perform: @escaping (_ stepInfo: STEP_DEFINITION.STEP, _ stepContent: STEP_DEFINITION.CONTENT, _ navigation: UINavigationController, _ currentFlowOutput: FlowOutput<STEP_DEFINITION.FLOW_OUTPUT>, @escaping ( _ output: STEP_DEFINITION.STEP_OUTPUT?) -> Void) -> Void
    ) -> StepHandler<STEP_DEFINITION> {
        .init(shouldBeDisplayed: shouldBeDisplayed, perform: perform)
    }

    public static func createWithEmptyOutput<STEP_DEFINITION: StepHandlerDefinition>(
        shouldBeDisplayed: ((_ stepContent: STEP_DEFINITION.CONTENT, _ displayConditions: [DisplayConditionProtocol]?, _ currentFlowOutput: FlowOutput<STEP_DEFINITION.FLOW_OUTPUT>) -> Bool)? = nil,
        perform: @escaping (_ stepInfo: STEP_DEFINITION.STEP, _ stepContent: STEP_DEFINITION.CONTENT, _ navigation: UINavigationController, _ currentFlowOutput: FlowOutput<STEP_DEFINITION.FLOW_OUTPUT>, @escaping () -> Void) -> Void
    ) -> StepHandler<STEP_DEFINITION> where STEP_DEFINITION.STEP_OUTPUT == StepOutputEmpty {
        .init(shouldBeDisplayed: shouldBeDisplayed, perform: perform)
    }

    public func shouldBeDisplayed(contentDecoder: Decoder, displayConditions: [DisplayConditionProtocol]?, currentFlowOutput: CurrentFlowOutput) -> Bool {
        guard let shouldBeDisplayed = shouldBeDisplayed, let content = try? STEP_DEFINITION.CONTENT(from: contentDecoder) else {
            return defaultShouldBeDisplayed(displayConditions: displayConditions, currentRawResult: currentFlowOutput.rawData)
        }

        return shouldBeDisplayed(content, displayConditions, FlowOutput<STEP_DEFINITION.FLOW_OUTPUT>(flowId: currentFlowOutput.flowId, rawData: currentFlowOutput.rawData, keyPathMapped: currentFlowOutput.keyPathMapped))
    }

    public func perform(stepInfo: STEP_DEFINITION.STEP, contentDecoder: Decoder, viewController: UINavigationController, currentFlowOutput: CurrentFlowOutput, registerOutputType: AnyKeyPath?, completion: @escaping (Any?) -> Void) throws {
        do {
            try perform(stepInfo, STEP_DEFINITION.CONTENT(from: contentDecoder), viewController, FlowOutput<STEP_DEFINITION.FLOW_OUTPUT>(flowId: currentFlowOutput.flowId, rawData: currentFlowOutput.rawData, keyPathMapped: currentFlowOutput.keyPathMapped), completion)
        } catch {
            throw StepHandlerError.stepContentNotDecodable(stepInfo: stepInfo)
        }
    }

    private func defaultShouldBeDisplayed(displayConditions: [DisplayConditionProtocol]?, currentRawResult: [String: Any]) -> Bool {
        guard let displayConditions = displayConditions, !displayConditions.isEmpty else { return true }
        return !displayConditions.contains { $0.match(input: currentRawResult) == false }
    }
}
extension StepHandler {
    enum StepHandlerError: Error {
        case stepContentNotDecodable(stepInfo: STEP_DEFINITION.STEP)
    }
}
