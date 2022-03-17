//
// Created by Alex Martinez on 14/05/2020.
//

import FlowKit

public struct Step: StepProtocol, Decodable, Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id &&
        lhs.type == rhs.type &&
        lhs.nextSteps == rhs.nextSteps
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
    public let displayConditions: [DisplayCondition]?
    
    public var nextSteps: [NextStep<NextStepCondition>]?
    public let contentDecoder: Decoder
    
    public init(
        id: String,
        type: String,
        nextSteps: [NextStep<NextStepCondition>]?,
        content: [String: Any],
        displayConditions: [DisplayCondition]?
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
        displayConditions = try? container.decode([DisplayCondition].self, forKey: .displayConditions)
        contentDecoder = try container.superDecoder(forKey: .content)
        
        if let nextStep = try? container.decode(String.self, forKey: .nextStep) {
            nextSteps = [NextStep(nextStepId: nextStep, conditions: nil)]
        } else {
            nextSteps = try? container.decode([NextStep].self, forKey: .nextSteps)
        }
    }
}

extension Step: Hashable {
    public func hash(into hasher: inout Hasher) {
        id.hash(into: &hasher)
    }
}
