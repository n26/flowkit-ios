//
// Created by Alex Martinez on 15/12/21.
//

import Foundation

public typealias NextStepConditionProtocol = StepConditionMatching & Decodable & Equatable

///
/// Next step condition interface
public protocol StepConditionMatching {
    func match(input: [String: Any]) -> Bool
}

///
/// Display conditions interface
public protocol DisplayConditionProtocol: Decodable {
    func match(input: [String: Any]) -> Bool
}

///
/// Step interface to be implement by the client
/// - Associated types
///     - DISPLAY_CONDITIONS: Display conditions concrete type
///     - NEXTSTEP_CONDITIONS: Next steps concrete type
/// - Properties
///     - id: Step identifier
///     - type: Step type represented by a String
///     - contentDecoder: Decoder to store the dynamic step content
///     - displayConditions: Optional Array with the display conditions used to evaluate if the step should be displayed
///     - nextSteps: Optional array with the next steps and their conditions. Used in case that the flow is non linear.
public protocol StepProtocol {
    associatedtype DISPLAY_CONDITIONS: DisplayConditionProtocol
    associatedtype NEXTSTEP_CONDITIONS: NextStepConditionProtocol
    var id: String { get }
    var type: String { get }
    var contentDecoder: Decoder { get }
    var displayConditions: [DISPLAY_CONDITIONS]? { get }
    var nextSteps: [NextStep<NEXTSTEP_CONDITIONS>]? { get }
}
