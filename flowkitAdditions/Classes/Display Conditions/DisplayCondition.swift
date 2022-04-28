//
// Created by Alex Martinez on 11/06/2020.
//

import N26FlowKitCore

public struct DisplayCondition: Decodable, Equatable, DisplayConditionProtocol {
    enum CodingKeys: String, CodingKey {
        case stepId
        case type
        case condition
    }

    public enum Condition: Equatable {
        case text(condition: TextDisplayCondition)
        case date(condition: DateDisplayCondition)
        case amount(condition: AmountDisplayCondition)
        case bool(condition: BoolDisplayCondition)

        var matcher: Matching {
            switch self {
            case .text(let condition):
                return condition
            case .amount(let condition):
                return condition
            case .date(let condition):
                return condition
            case .bool(let condition):
                return condition
            }
        }
    }

    public let stepId: String
    public let condition: Condition

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        stepId = try container.decode(String.self, forKey: .stepId)
        
        let conditionType = try container.decode(String.self, forKey: .type)
        
        switch conditionType {
        case "TEXT":
            condition = .text(
                condition: try container.decode(
                    TextDisplayCondition.self,
                    forKey: .condition)
            )
            
        case "AMOUNT":
            condition = .amount(
                condition: try container.decode(
                    AmountDisplayCondition.self,
                    forKey: .condition)
            )
            
        case "DATE":
            condition = .date(
                condition: try container.decode(
                    DateDisplayCondition.self,
                    forKey: .condition)
            )
            
        case "BOOL":
            condition = .bool(
                condition: try container.decode(
                    BoolDisplayCondition.self,
                    forKey: .condition)
            )
            
        default:
            throw DecodingError.dataCorruptedError(
                forKey: .condition,
                in: container,
                debugDescription: "Unknown display condition type."
            )
        }
    }

    public init(stepId: String, condition: Condition) {
        self.stepId = stepId
        self.condition = condition
    }

    public func match(input: [String: Any]) -> Bool {
        condition.matcher.match(stepId: stepId, input: input)
    }
}
