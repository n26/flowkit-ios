//
// Created by Alex Martinez on 19/06/2020.
//

import Foundation

public protocol FlowOutputDefinition { }

///
/// Use when access to steps output data in the middle/end of a flow is not needed
///
public struct FlowOutputEmptyDefinition: FlowOutputDefinition { }

public struct CurrentFlowOutput {
    public let flowId: String
    public let rawData: [String: Any]
    let keyPathMapped: [AnyKeyPath: String]

    public init(flowId: String, rawData: [String: Any], keyPathMapped: [AnyKeyPath: String]) {
        self.flowId = flowId
        self.rawData = rawData
        self.keyPathMapped = keyPathMapped
    }
}

///
/// Class to store all the steps output that would allow to access them in a safe typed way.
/// - Generics
///     - OUTPUT: Flow output definition
@dynamicMemberLookup
public final class FlowOutput<OUTPUT: FlowOutputDefinition> {
    ///
    /// The flow identifier
    public let flowId: String
    ///
    /// Dictionary with the pair *stepId: StepOutput* .So the output can be accessed through the *stepId* and the value has to be casted.
    public let rawData: [String: Any]
    private let keyPathMapped: [AnyKeyPath: String]

    init(flowId: String, rawData: [String: Any], keyPathMapped: [AnyKeyPath: String] = [:]) {
        self.flowId = flowId
        self.rawData = rawData
        self.keyPathMapped = keyPathMapped
    }

    public subscript<T: StepOutput>(dynamicMember keyPath: KeyPath<OUTPUT, T>) -> T? {
        guard let stepId = keyPathMapped[keyPath] else { return nil }
        return rawData[stepId] as? T
    }
}
