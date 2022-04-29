//
// Created by Alex Martinez on 17/12/2020.
//

public struct BoolDisplayCondition: Decodable, Equatable {
    public let value: Bool
    
    public init(value: Bool) {
        self.value = value
    }
}

extension BoolDisplayCondition: Matching {
    func match(stepId: String, input: [String: Any]) -> Bool {
        guard let valueAnswered = input[stepId] as? Bool else {
            return false
        }
        
        return value == valueAnswered
    }
}
