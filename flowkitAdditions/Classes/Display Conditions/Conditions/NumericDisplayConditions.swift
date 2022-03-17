//
// Created by Alex Martinez on 11/06/2020.
//

public struct NumericDisplayConditions: Decodable, Equatable {
    public let minAmount: Double?
    public let maxAmount: Double?
    
    public init(minAmount: Double?, maxAmount: Double?) {
        self.minAmount = minAmount
        self.maxAmount = maxAmount
    }
}

extension NumericDisplayConditions: Matching {
    func match(stepId: String, input: [String: Any]) -> Bool {
        guard let amountAnswered = input[stepId] as? Double else {
            return false
        }
        
        if let min = minAmount {
            guard amountAnswered >= min else { return false }
        }
        
        if let max = maxAmount {
            guard amountAnswered <= max else { return false }
        }
        
        return true
    }
}
