//
// Created by Alex Martinez on 14/05/2020.
//

import Foundation

indirect enum StepsTree<STEP: StepProtocol>: Equatable {
    case none
    case node(stepInfo: AnyStep<STEP>, next: [StepsTree<STEP>])
    case error(error: StepError)

    var nextSteps: [StepsTree<STEP>] {
        switch self {
        case .none:
            return [.none]
        case .node(_, let next):
            return next
        case .error:
            return []
        }
    }

    var stepInfo: AnyStep<STEP>? {
        switch self {
        case .none, .error:
            return nil
        case .node(let info, _):
            return info
        }
    }

    init(initialStepId: String, stepsInfo: [AnyStep<STEP>]) {
        guard !stepsInfo.isEmpty else {
            self = .none
            return
        }

        func create(currentStep: AnyStep<STEP>, stepsInfo: Set<AnyStep<STEP>>, nextSteps: Set<AnyStep<STEP>>?, nodes: [String])  -> StepsTree<STEP> {
            guard !nodes.contains(currentStep.id) else {
                return .error(error: StepError.flowMalformed(stepId: currentStep.id))
            }

            guard let nextSteps = nextSteps, nextSteps.count > 0 else {
                return StepsTree.node(stepInfo: currentStep, next: [.none])
            }

            var currentNodes = nodes
            currentNodes.append(currentStep.id)

            return StepsTree.node(
                stepInfo: currentStep,
                next: nextSteps.map { nextStepInfo in
                    let nextStepsInfo = stepsInfo.filter { step in
                        nextStepInfo.nextSteps?.contains { $0.nextStepId == step.id } ?? false
                    }

                    guard nextStepsInfo.isSubset(of: stepsInfo)
                              && (nextStepsInfo.count == nextStepInfo.nextSteps?.count ?? 0) else {
                        return .error(error: StepError.stepNotFound(stepId: nextStepInfo.id))
                    }

                    return create(
                        currentStep: nextStepInfo,
                        stepsInfo: stepsInfo,
                        nextSteps: nextStepsInfo,
                        nodes: currentNodes
                    )
                }
            )
        }

        let step = stepsInfo.first { $0.id == initialStepId }

        guard let initialStep = step else {
            self = .error(error: StepError.initialStepNotFound(stepId: initialStepId))
            return
        }

        let stepsInfoSet = Set<AnyStep<STEP>>(stepsInfo)

        self = create(
            currentStep: initialStep,
            stepsInfo: stepsInfoSet,
            nextSteps: stepsInfoSet.filter { stepInfo in
                initialStep.nextSteps?.contains { $0.nextStepId == stepInfo.id } ?? false
            },
            nodes: []
        )
    }
}

public enum StepError: Error, Equatable {
    case initialStepNotFound(stepId: String)
    case stepNotFound(stepId: String)
    case flowMalformed(stepId: String)
}
