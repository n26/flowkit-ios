//
// Created by Alex Martinez on 22/05/2020.
//

import Foundation

///
/// Struct to handle the required data for a flow
/// - Generics
///     - STEP: A concrete Step
/// - Important: STEP type must match with the step type used in [flow definition](x-source-tag://FlowDefinition) and in the [step factory](x-source-tag://StepFactory).
public struct FlowData<STEP: StepProtocol & Decodable>: Decodable, Equatable {
    enum CodingKeys: String, CodingKey {
        case id
        case initialStepId
        case steps
    }

    let id: String
    let initialStepId: String
    var stepsInfo: [AnyStep<STEP>]

    ///
    /// Use this constructor if you would like to define a flow programmatically
    /// - Parameters:
    ///   - id: Flow identifier
    ///   - initialStepId: Initial step identifier that FlowKit will use to start the flow
    ///   - stepsInfo: Array of steps
    public init(id: String, initialStepId: String, stepsInfo: [STEP]) {
        self.id = id
        self.initialStepId = initialStepId
        self.stepsInfo = stepsInfo.map { AnyStep($0) }
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        initialStepId = try container.decode(String.self, forKey: .initialStepId)
        let stepsInfoRaw = try container.decode([STEP].self, forKey: .steps)

        stepsInfo = stepsInfoRaw.map {
            AnyStep<STEP>($0)
        }
    }

    ///
    /// Append a flow to the final step of the current flow
    /// - Parameter flow: Flow to be appended
    /// - Returns: A new flow data with both flows
    public func appending(_ flow: FlowData<STEP>) -> FlowData<STEP> {
        var mergedSteps = stepsInfo
        if var lastStep = stepsInfo.last {
            lastStep.nextSteps = [NextStep(nextStepId: flow.initialStepId, conditions: nil)]
            mergedSteps = stepsInfo.dropLast()
            mergedSteps.append(lastStep)
        }
        
        mergedSteps.append(contentsOf: flow.stepsInfo)
        
        var mergedFlow = self
        mergedFlow.stepsInfo = mergedSteps
        
        return mergedFlow
    }
}
