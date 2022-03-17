//
// Created by Alex Martinez on 14/05/2020.
//

import Foundation
import FlowKit

public struct StepMock: StepProtocol, Decodable {
    public struct DisplayConditionMock: DisplayConditionProtocol {
        private let shouldMatch: Bool
        
        init(shouldMatch: Bool = false) {
            self.shouldMatch = shouldMatch
        }
        
        public func match(input: [String: Any]) -> Bool {
            shouldMatch
        }
    }

    public struct NextStepConditionMock: NextStepConditionProtocol {
        private let shouldMatch: Bool

        init(shouldMatch: Bool = false) {
            self.shouldMatch = shouldMatch
        }

        public func match(input: [String: Any]) -> Bool {
            shouldMatch
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case stepType = "type"
        case content
        case nextStep
        case displayConditions
        case nextSteps
    }
    
    public let id: String
    public let type: String
    public let displayConditions: [DisplayConditionMock]?
    
    public var nextSteps: [NextStep<NextStepConditionMock>]?
    public let contentDecoder: Decoder
    
    public init(
        id: String,
        type: String,
        nextSteps: [NextStep<NextStepConditionMock>]?,
        content: [String: Any],
        displayConditions: [DisplayConditionMock]?
    ) throws {
        let payload: [String: Any] = [
            CodingKeys.id.rawValue: id,
            CodingKeys.stepType.rawValue: type,
            CodingKeys.content.rawValue: content
        ]
        
        let data = try JSONSerialization.data(withJSONObject: payload, options: .prettyPrinted)
        let model = try JSONDecoder().decode(Self.self, from: data)
        self.id = model.id
        self.type = model.type
        self.contentDecoder = model.contentDecoder
        self.displayConditions = displayConditions
        self.nextSteps = nextSteps
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        type = try container.decode(String.self, forKey: .stepType)
        displayConditions = try? container.decode([DisplayConditionMock].self, forKey: .displayConditions)
        contentDecoder = try container.superDecoder(forKey: .content)
        
        if let nextStep = try? container.decode(String.self, forKey: .nextStep) {
            nextSteps = [NextStep(nextStepId: nextStep, conditions: nil)]
        } else {
            nextSteps = try? container.decode([NextStep].self, forKey: .nextSteps)
        }
    }
}

extension StepMock: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id &&
        lhs.type == rhs.type &&
        lhs.nextSteps == rhs.nextSteps
    }
}

extension StepMock: Hashable {
    public func hash(into hasher: inout Hasher) {
        id.hash(into: &hasher)
    }
}
