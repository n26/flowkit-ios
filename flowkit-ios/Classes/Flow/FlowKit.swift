//
// Created by Guillem Sole on 16/12/2021.
//

import Foundation

import UIKit

///
/// FlowKit struct
/// - Generics
///     - FLOW: The flow definition. [FlowDefinition](x-source-tag://FlowDefinition)
public struct FlowKit<FLOW: FlowDefinition> {
    private let id: String
    private let step: StepsTree<FLOW.STEP>
    private let featureStepFactory: AnyStepFactory<FLOW.STEP, FLOW.OUTPUT>

    ///
    /// Main Flow constructor
    /// - Parameters:
    ///   - flowData: Data required to build the flow
    ///   - featureStepFactory: Factory for creating your steps
    public init<T: StepFactory>(
        flowData: FlowData<FLOW.STEP>,
        featureStepFactory: T
    ) where T.OUTPUT == FLOW.OUTPUT, T.STEP == FLOW.STEP {
        self.id = flowData.id
        self.featureStepFactory = AnyStepFactory(featureStepFactory)
        self.step = StepsTree<FLOW.STEP>(initialStepId: flowData.initialStepId, stepsInfo: flowData.stepsInfo)
    }

    ///
    /// Call this method to start the flow
    /// - Parameters:
    ///   - navigation: Navigation controller where start the flow
    ///   - willPerformStep: Closure executed when a new step is going to be performed
    ///   - onErrorHandler: Closure executed when flow or step throw an error
    ///   - onFinish: Closure executed when the flow is finished
    public func start(
        on navigation: UINavigationController,
        willPerformStep: ((FLOW.STEP) -> Void)? = nil,
        onErrorHandler: ((FlowKit.FlowError, UINavigationController) -> Void)? = nil,
        onFinish: @escaping (FlowOutput<FLOW.OUTPUT>) -> Void
    ) {
        do {
            try verifyFlowIntegrity(for: step)
            perform(
                step: step,
                navigation: navigation,
                flowOutput: CurrentFlowOutput(flowId: id, rawData: [:], keyPathMapped: [:]),
                willPerformStep: willPerformStep,
                onErrorHandler: onErrorHandler,
                onFinish: onFinish
            )
        } catch {
            guard let error = error as? FlowError else {
                onErrorHandler?(FlowError.unknownError, navigation)
                return
            }
            onErrorHandler?(error, navigation)
        }
    }

    private func perform(
        step: StepsTree<FLOW.STEP>,
        navigation: UINavigationController,
        flowOutput: CurrentFlowOutput,
        willPerformStep: ((FLOW.STEP) -> Void)?,
        onErrorHandler: ((FlowKit.FlowError, UINavigationController) -> Void)?,
        onFinish: @escaping (FlowOutput<FLOW.OUTPUT>) -> Void
    ) {
        guard case .node(let stepInfo, _) = step else {
            onFinish(FlowOutput<FLOW.OUTPUT>(flowId: id, rawData: flowOutput.rawData, keyPathMapped: flowOutput.keyPathMapped))
            return
        }

        guard let stepHandler = featureStepFactory.makeHandler(for: stepInfo.type) else { return }

        guard stepHandler.shouldBeDisplayed(contentDecoder: stepInfo.contentDecoder, displayConditions: step.stepInfo?.displayConditions, currentFlowOutput: flowOutput) else {
            do {
                perform(
                    step: try nextStep(for: step, flowOutput: flowOutput.rawData),
                    navigation: navigation,
                    flowOutput: flowOutput,
                    willPerformStep: willPerformStep,
                    onErrorHandler: onErrorHandler,
                    onFinish: onFinish
                )
            } catch {
                onErrorHandler?(FlowError.multipleMatchingConditions(stepInfo: stepInfo.stepRaw), navigation)
            }

            return
        }

        willPerformStep?(stepInfo.stepRaw)

        do {
            try stepHandler.perform(stepInfo: stepInfo.stepRaw, contentDecoder: stepInfo.contentDecoder, viewController: navigation, currentFlowOutput: flowOutput, registerOutputType: stepHandler.registerOutputKeyPath) { [weak navigation] output in
                guard let navigation = navigation else {
                    assert(false, "navigation shouldn't be deallocated")
                    return
                }

                let result: [String: Any]
                let keyPathMapped: [AnyKeyPath: String]

                if let output = output {
                    result = flowOutput.rawData.merging([stepInfo.id: output]) { _, new in new }

                    if let keyPathToRegister = stepHandler.registerOutputKeyPath {
                        assert(!flowOutput.keyPathMapped.keys.contains(keyPathToRegister), "flowkit: Keypath \(keyPathToRegister) already used")
                        keyPathMapped = flowOutput.keyPathMapped.merging([keyPathToRegister: stepInfo.id]) { _, new in new }
                    } else {
                        keyPathMapped = flowOutput.keyPathMapped
                    }
                } else {
                    result = flowOutput.rawData
                    keyPathMapped = flowOutput.keyPathMapped
                }

                do {
                    perform(
                        step: try nextStep(for: step, flowOutput: result),
                        navigation: navigation,
                        flowOutput: CurrentFlowOutput(flowId: id, rawData: result, keyPathMapped: keyPathMapped),
                        willPerformStep: willPerformStep,
                        onErrorHandler: onErrorHandler,
                        onFinish: onFinish
                    )
                } catch {
                    onErrorHandler?(FlowError.multipleMatchingConditions(stepInfo: stepInfo.stepRaw), navigation)
                }
            }
        } catch {
            onErrorHandler?(FlowError.stepContentNotDecodable(stepInfo: stepInfo.stepRaw), navigation)
        }
    }

    private func nextStep(for currentStep: StepsTree<FLOW.STEP>, flowOutput: [String: Any]) throws -> StepsTree<FLOW.STEP> {
        switch currentStep {
        case .none, .error:
            return .none
        case .node(let stepInfo, let nextSteps):
            guard !isFinalStep(stepInfo: stepInfo) else {
                return .none
            }

            guard let matchingNextStepId = try matchingNextStepId(stepInfo: stepInfo, flowOutput: flowOutput) else {
                guard let defaultNextStepId = try defaultNextStepId(stepInfo: stepInfo) else {
                    return .none
                }

                return nextSteps.first {
                    switch $0 {
                    case .none, .error:
                        return false
                    case .node(let stepInfo, _):
                        return stepInfo.id == defaultNextStepId
                    }
                } ?? .none
            }

            return nextSteps.first {
                switch $0 {
                case .none, .error:
                    return false
                case .node(let stepInfo, _):
                    return stepInfo.id == matchingNextStepId
                }
            } ?? .none
        }
    }

    private func defaultNextStepId(stepInfo: AnyStep<FLOW.STEP>) throws -> String? {
        guard let stepsConditions = stepInfo.nextSteps else { return nil }

        let nextDefaultSteps = stepsConditions.filter { $0.isDefaultStep }

        guard !nextDefaultSteps.isEmpty else { return nil }

        guard nextDefaultSteps.count == 1 else {
            throw FlowError.multipleMatchingConditions(stepInfo: stepInfo.stepRaw)
        }

        return nextDefaultSteps[0].nextStepId
    }

    private func isFinalStep(stepInfo: AnyStep<FLOW.STEP>) -> Bool {
        stepInfo.nextSteps?.isEmpty ?? true
    }

    private func matchingNextStepId(stepInfo: AnyStep<FLOW.STEP>, flowOutput: [String: Any]) throws -> String? {
        guard let stepsConditions = stepInfo.nextSteps else { return nil }

        let nextStepsMatching = stepsConditions.filter {
            guard let stepConditions = $0.conditions, !stepConditions.isEmpty else {
                return false
            }
            return !stepConditions.contains { $0.match(input: flowOutput) == false }
        }

        guard !nextStepsMatching.isEmpty else { return nil }

        guard nextStepsMatching.count == 1 else {
            throw FlowError.multipleMatchingConditions(stepInfo: stepInfo.stepRaw)
        }

        return nextStepsMatching[0].nextStepId
    }

    private func verifyFlowIntegrity(for step: StepsTree<FLOW.STEP>) throws {
        switch step {
        case .none:
            return
        case .error(let error):
            throw FlowError.cannotCreateFlow(stepError: error)
        case .node(let stepInfo, let nextSteps):
            guard featureStepFactory.makeHandler(for: stepInfo.type) != nil else {
                throw FlowError.cannotCreateStepHandler(stepInfo: stepInfo.stepRaw)
            }

            try nextSteps.forEach {
                try verifyFlowIntegrity(for: $0)
            }
        }
    }
}

extension FlowKit {
    public enum FlowError: Error {
        case multipleMatchingConditions(stepInfo: FLOW.STEP)
        case cannotCreateStepHandler(stepInfo: FLOW.STEP)
        case stepContentNotDecodable(stepInfo: FLOW.STEP)
        case cannotCreateFlow(stepError: StepError)
        case unknownError
    }
}
