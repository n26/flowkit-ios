//
// Created by Alex Martinez on 14/10/2020.
//

import FlowKit

public struct NextStepCondition: NextStepConditionProtocol {
    enum CodingKeys: String, CodingKey {
        case type
        case condition
    }
    
    enum Condition: Equatable {
        case text(condition: TextNextStepsCondition)
        case date(condition: DateNextStepsCondition)
        case numeric(condition: NumericNextStepsCondition)
        
        var matcher: StepConditionMatching {
            switch self {
            case let .text(condition):
                return condition
            case let .numeric(condition):
                return condition
            case let .date(condition):
                return condition
            }
        }
    }
    
    let condition: Condition
    
    init(condition: Condition) {
        self.condition = condition
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let conditionType = try container.decode(String.self, forKey: .type)
        switch conditionType {
        case "TEXT":
            condition = .text(
                condition: try container.decode(
                    TextNextStepsCondition.self,
                    forKey: .condition
                )
            )
            
        case "NUMERIC":
            condition = .numeric(
                condition: try container.decode(
                    NumericNextStepsCondition.self,
                    forKey: .condition
                )
            )
            
        case "DATE":
            condition = .date(
                condition: try container.decode(
                    DateNextStepsCondition.self,
                    forKey: .condition
                )
            )
            
        default:
            throw DecodingError.dataCorruptedError(
                forKey: .condition,
                in: container,
                debugDescription: "Unknown next step condition type."
            )
        }
    }
    
    public func match(input: [String: Any]) -> Bool {
        condition.matcher.match(input: input)
    }
}
