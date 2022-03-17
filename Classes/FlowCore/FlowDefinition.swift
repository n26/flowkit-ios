//
// Created by Alex Martinez on 15/12/21.
//

import Foundation

public protocol FlowDefinition {
    associatedtype OUTPUT: FlowOutputDefinition
    associatedtype STEP: StepProtocol & Decodable
}
