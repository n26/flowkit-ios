//
// Created by Alex Martinez on 15/12/21.
//

import Foundation

public typealias NextStepConditionProtocol = StepConditionMatching & Decodable & Equatable

public protocol StepConditionMatching {
    func match(input: [String: Any]) -> Bool
}

public protocol DisplayConditionProtocol: Decodable {
    func match(input: [String: Any]) -> Bool
}

public protocol StepProtocol {
    associatedtype DISPLAY_CONDITIONS: DisplayConditionProtocol
    associatedtype NEXTSTEP_CONDITIONS: NextStepConditionProtocol
    var id: String { get }
    var type: String { get }
    var contentDecoder: Decoder { get }
    var displayConditions: [DISPLAY_CONDITIONS]? { get }
    var nextSteps: [NextStep<NEXTSTEP_CONDITIONS>]? { get }
}
