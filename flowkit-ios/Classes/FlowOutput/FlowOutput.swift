//
// Created by Alex Martinez on 19/06/2020.
//

import Foundation

///
/// Protocol that a Context has to conforms. All the types have to conform to *StepOutput*
///
///     struct YourFlowDefinition: FlowOutputDefinition {
///         let transactionId: String
///         let selectedOffer: Offer
///     }
public protocol FlowOutputDefinition { }

///
/// Use **EmptyOutputDefinition** when you don't need the context
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
/// Class to store all the steps output in a concrete context. It can be accessed through:
/// **rawData:** Dictionary with the pair *stepId: StepOutput* .So the output can be accessed through the *stepId* and the value has to be casted.
/// **serializableDict:** Dictionary with the pair *stepId: StepOutput* . So the output can be accessed through the *stepId* and the value is serializable (e.g. for network requests)
/// **FlowOutputContext:** Define a context that is type safe and allow you to use autocompletion.
/// The output can be accessed through the properties defined in the context. The *stepId* is automatically linked so it's not needed to access the data.
///
@dynamicMemberLookup
public final class FlowOutput<OUTPUT: FlowOutputDefinition> {
    public let flowId: String
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
