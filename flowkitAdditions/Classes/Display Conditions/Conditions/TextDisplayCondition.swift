//
// Created by Alex Martinez on 11/06/2020.
//

public struct TextDisplayCondition: Decodable, Equatable {
    public let values: [String]
    
    public init(values: [String]) {
        self.values = values
    }
}

extension TextDisplayCondition: Matching {
    func match(stepId: String, input: [String: Any]) -> Bool {
        guard let valueAnswered = input[stepId] as? String else {
            return false
        }
        
        return values.contains(valueAnswered)
    }
}
